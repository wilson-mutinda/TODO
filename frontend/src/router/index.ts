import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import HomePage from '@/pages/HomePage.vue'
import TaskPage from '@/pages/TaskPage.vue'
import LoginForm from '@/forms/LoginForm.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', name: 'home', component: HomePage },
    { path: '/tasks', name: 'tasks', component: TaskPage },
    { path: '/login', name: 'login', component: LoginForm },

  ],
})

export default router
