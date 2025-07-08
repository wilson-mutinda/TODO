<template>
    <div class="form-template bg-gray-500 flex justify-center items-center min-h-screen">
        <div class="login-form bg-white w-full max-w-md p-4 rounded-md shadow-md">
            <form action="" @submit.prevent="userLogin">
                <h3 class="text-green-700 text-center font-bold">Login</h3>
                <div class="space-y-4">
                    <div class="">
                        <label for="email" class="block font-semibold">Email</label>
                        <input type="email" @input="setErrorNull('email'    )" name="email" v-model="email" class="w-full px-4 py-2 outline-none rounded-md ring-1 focus:ring-red-300" required >
                        <p v-if="errors.email" class="text-red-700">{{ errors.email }}</p>
                    </div>

                    <div class="relative">
                        <label for="password" class="block font-semibold">Password</label>
                        <input :type="textPassword ? 'text' : 'password'" @input="setErrorNull('password')" name="password" v-model="password" class="w-full px-4 py-2 outline-none rounded-md ring-1 focus:ring-red-300" required >
                        <button type="button" class="absolute top-9 right-3 bg-transparent" @click="viewPassword">
                            <img :src="textPassword ? 'hide.png' : 'show.png'" alt="hide" width="12px">
                        </button>
                        <p v-if="errors.password" class="text-red-700">{{ errors.password }}</p>
                    </div>
                </div>

                <!-- submit button -->
                <button type="submit" class="w-full bg-blue-400 mt-4 rounded-md p-2 text-white font-semibold hover:bg-blue-200" :disabled="loading">
                    <span v-if="!loading">Login</span>
                    <span v-else class="flex items-center justify-center gap-2">
                        <!-- Spinner -->
                        <svg class="animate-spin h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        <span>Loading...</span>
                    </span>
                </button>
            </form>
        </div>
    </div>
</template>

<script>
import api from '@/services/api';

export default {

    data() {
        return {
            email: '',
            password: '',

            errors: {},

            textPassword: '',

            loading: false,
        }
    },

    methods: {

        // setErrorNull
        setErrorNull(field) {
            this.errors[field] = ''
        },

        // viewPassword
        viewPassword() {
            this.textPassword = !this.textPassword
        },

        // clearAll
        clearAll() {
            this.email = '',
            this.password = ''
        },

        // userLogin
        async userLogin() {
            this.loading = true;

            try {
                const payload = {
                    email: this.email,
                    password: this.password
                }
                const response = await api.post('user_login/', payload)
                // acees and refresh token
                localStorage.setItem('access_token', response.data.access_token);
                localStorage.setItem('refresh_token', response.data.refresh_token);
                localStorage.setItem('token_created_at', new Date().getTime().toString());

                this.clearAll()

                setTimeout(() => {
                    this.$router.push('/tasks');
                }, 1000);

            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors = { general: "Something went wrong!"}
                }
            } finally {
                this.loading = false;
            }
        }
    }

}
</script>
