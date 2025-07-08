import axios from "axios";

const api = axios.create({
    baseURL: "http://127.0.0.1:3000/api/v1/",
    headers: {
        'Content-Type': 'application/json'
    }
});
// REQUEST INTERCEPTOR
api.interceptors.request.use(config => {
    const token = localStorage.getItem('access_token')
    if (token) {
        // embed the access_token to every request made
        config.headers.Authorization = `Bearer ${token}`
    }
    return config
})

// RESPONSE INTERCEPTOR
api.interceptors.response.use(
    response => response,

    async error => {
        // get the errorResponse
        const errorResponse = error.config;

        // check if its a 401 error, and if its not retried to retry
        if (error.response.status === 401 && !errorResponse._retry) {
            errorResponse._retry = true

            // get the refreshToken
            const refreshToken = localStorage.getItem('refresh_token')

            try {
                // get a newAccessToken with the refreshToken
                const refreshResponse = await api.post('refresh_token', {}, {
                    headers: {
                        Authorization: `Bearer ${refreshToken}`
                    }
                });
    
                const newAccessToken = refreshResponse.data.new_access_token
    
                // set the accessToken to newAccessToken
                localStorage.setItem('access_token', newAccessToken)
    
                // reset errorResponse to use the newAccessToken
                errorResponse.headers.Authorization = `Bearer ${newAccessToken}`
    
                return api(errorResponse)
            } catch (refreshError) {
                localStorage.removeItem('access_token');
                localStorage.removeItem('refresh_token');
                window.location.href = '/login';
                return Promise.reject(refreshError);
            }
        }
        return Promise.reject(error)
    }
)

export default api
