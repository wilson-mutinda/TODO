import api from "./api";

export function setupTokenTimers() {
    const createdAtStr = localStorage.getItem('token_created_at');

    if (!createdAtStr) return;

    const createdAt = parseInt(createdAtStr, 10)

    const now = new Date().getTime();

    // time left before 30-mminute access token expires
    const timeUntilRefresh = Math.max(0, (30 * 60 * 1000) - (now - createdAt));

    // time left before 24-hour refresh token expires
    const timeUntilLogout = Math.max(0, (24 * 60 * 60 * 1000) - (now - createdAt));

    // refresh token after 30-minutes
    setTimeout(async () => {
        const refreshToken = localStorage.getItem('refresh_token');

        try {
            const response = await api.get('refresh_token.json', {
                headers: {
                    'Authorization': `Bearer ${refreshToken}`,
                    "Content-Type": 'application/json',
                    "Accept": 'application/json',
                }
            });
    
            const newAccessToken = response.data.new_access_token;
            localStorage.setItem('access_token', newAccessToken);
            localStorage.setItem('token_created_at', new Date().getTime().toString());
    
            setupTokenTimers();
        } catch (error) {
            console.error('Token refresh failed:', error);
            logoutUser();            
        }
    }, timeUntilRefresh);

    setTimeout(() => {
        logoutUser();
    }, timeUntilLogout);
}

export function logoutUser() {
    localStorage.removeItem('access_token');
    localStorage.removeItem('refresh_token');
    localStorage.removeItem('token_created_at');
    window.location.href = '/login';
}
