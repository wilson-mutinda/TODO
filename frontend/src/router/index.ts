import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import LoginForm from '../Forms/loginForm.vue'
import Tasks from '../Pages/taskPage.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/login', name: 'login', component: LoginForm },
    { path: '/tasks', name: 'tasks', component: Tasks }
  ],
})

export default router
