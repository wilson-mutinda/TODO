<template>
    <div class="bg-gray-100 min-h-screen flex items-center justify-center">
        <!-- login form -->
         <div class="bg-white rounded-md p-4 w-full max-w-md relative">
            <form @submit.prevent="loginUser" action="" method="post">

                <!-- close button -->
                 <button @click="closeButton" type="button" class="absolute right-4">
                    <img src="/close.png" alt="close" width="20">
                 </button>

                <h3 class="text-center font-bold text-2xl mb-2">Login</h3>

                <!-- general error -->
                 <span v-if="errors.general" class="text-red-600 text-center text-sm">{{errors.general}}</span>

                <!-- email -->
                 <div class="">
                    <label class="block text-gray-600 text-lg mb-2" for="email">Email</label>
                    <input @input="clearError('email')" v-model="email" class="rounded-md p-2 w-full outline-none ring-1 ring-gray-600 hover:ring-blue-600 mb-2" type="email" name="email" id="email">
                    <!-- error -->
                     <span v-if="errors.email" class="text-red-600 text-sm">{{ errors.email }}</span>
                 </div>

                 <!-- password -->
                  <div class="relative">
                    <label class="block text-gray-600 text-lg mb-2" for="password">Password</label>
                    <input @input="clearError('password')" v-model="password" class="rounded-md p-2 w-full outline-none ring-1 ring-gray-600 hover:ring-blue-600 mb-2" :type="showPassword ? 'text' : 'password'" name="password" id="password">
                    <!-- error -->
                     <span v-if="errors.password" class="text-red-600 text-sm">{{ errors.password }}</span>
                    <!-- hide button -->
                     <button @click="togglePassword" type="button" class="absolute right-4 top-10">
                        <img :src="showPassword ? '/hide.png' : '/show.png'" alt="hide" width="30">
                     </button>
                  </div>

                  <!-- forgot password? -->
                   <div class="flex justify-end">
                    <a class="text-blue-600 font-bold mb-2" href="">Forgot password?</a>
                   </div>

                  <!-- login button -->
                   <div class="">
                    <button type="submit" class="rounded-md w-full mt-2 mb-2 bg-blue-600 text-white p-2 text-lg">Login</button>
                   </div>

                   <!-- or -->
                    <div class="flex items-center justify-center">
                        <div class="bg-gray-600 h-px flex flex-grow"></div>
                        <span class="p-2 text-gray-600 font-bold">OR</span>
                        <div class="bg-gray-600 h-px flex flex-grow"></div>
                    </div>

                    <!-- google login -->
                     <div class="">
                        <button @click="googleLogin" type="button" class="w-full mt-4 mb-2 flex items-center justify-center gap-3 ring-1 p-2 rounded-md ring-gray-600">
                            <img src="/google.png" alt="google" width="20">
                            <span class="font-bold">Continue with Google</span>
                        </button>
                     </div>

                     <!-- sign up -->
                      <div class="flex justify-center">
                        <span class="mt-2 mb-2">Don't have an account? <a class="text-blue-600 font-bold" href="">SignUp</a></span>
                      </div>
            </form>
         </div>
    </div>
</template>

<script>
import router from '@/router';
import api from '@/services/api';

export default {
    methods: {

        closeButton(){
            router.push('/')
        },

        googleLogin(){
            const client = google.accounts.oauth2.initTokenClient({
                client_id: "896684973847-fihoe5ppuhiv0cjalabq02ia7r1h1tle.apps.googleusercontent.com",
                scope: "email profile openid",
                callback: async (response) => {
                    try {
                        const payload = { token: response.access_token };
                        const res = await api.post('google_login', payload);
    
                        console.log("Google Login Successful: ", res.data);
                        router.push('/');
                    } catch (error) {
                        console.error("Google login error", error);
                        this.errors.general = "Google login failed. Try again..."
                    }
                }
            });

            // open Google popup when button is clicked
            client.requestAccessToken();
        },

        clearError(field){
            if (this.errors[field]) {
                this.errors = ''
            }
        },

        async loginUser(){
            try {
                const payload = {
                    email: this.email,
                    password: this.password
                }
                const response = await api.post('user_login', payload)
                console.log('Login Successful!:', response.data)
                this.email = ''
                this.password = ''
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors.general = 'Something went wrong!'
                }
            }
        },

        togglePassword() {
            this.showPassword = !this.showPassword
        },
    },

    data() {
        return {
            showPassword: false,

            email: '',
            password: '',

            errors: {}
        }
    }

}
</script>
