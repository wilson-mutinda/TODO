<template>
    <div class="bg-gray-100 min-h-screen">
        <!-- navbar -->
         <nav class="bg-white shadow-md py-4">
            <div class="container mx-auto px-4 flex items-center justify-between">
               <!-- logo -->
                <div class="flex items-center gap-2">
                  <img src="/checklist(1).png" alt="logo" width="50">
                  <span class="text-3xl text-blue-600 font-bold">MY-TODO</span>
                </div>
                <!-- desktop menu -->
                 <div class="hidden md:flex items-center gap-4">
                  <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">Home</a>
                  <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">About Us</a>
                  <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">Features</a>
                  <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">Contact Us</a>
                  <router-link to="/login" class="bg-blue-600 rounded-md px-4 py-2 text-white text-lg font-bold">
                     Login
                  </router-link>
                 </div>

                 <!-- mobile menu -->
                  <div class="block md:hidden">
                     <button type="button" @click="viewMenu">
                        <img src="/dial-pad.png" alt="mobile" width="40">
                     </button>
                  </div>
            </div>
            <!-- menu -->
             <div v-if="showMenu" class="md:hidden flex flex-col items-center gap-4 bg-gray-200">
               <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">Home</a>
               <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">About Us</a>
               <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">Features</a>
               <a class="text-gray-600 text-lg font-bold hover:text-blue-600" href="#">Contact Us</a>
               <router-link to="/login" class="bg-blue-600 rounded-md px-4 py-2 text-white text-lg font-bold">Login</router-link>
             </div>
         </nav>

         <!-- hero section -->
         <section>
            <div class=""></div>
         </section>

         <!-- featured section -->
         <section>
            <div class=""></div>
         </section>

         <!-- about section -->
         <section>
            <div class=""></div>
         </section>

         <!-- features section -->
         <section>
            <div class=""></div>
         </section>

         <!-- contact us section -->
         <section>
            <div class=""></div>
         </section>
    </div>
</template>

<script>
export default {
   data() {
      return {
         showMenu: false
      }
   },

   methods: {
      viewMenu() {
         this.showMenu = !this.showMenu
      }
   }
}
</script>
