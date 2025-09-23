<template>
  <div class="bg-gray-100 min-h-screen p-6">
    
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <!-- todo -->
      <div class="bg-white rounded-md shadow-md p-4">
        <div class="flex items-center justify-between mb-2">
          <h3 class="text-gray-600 font-bold text-xl text-center">TODO TASKS</h3>
          <span class="bg-blue-600 text-white text-sm font-semibold px-3 py-1 rounded-full shadow">{{ totalUndone }}</span>
        </div>

        <!-- action buttons -->
         <div class="flex items-center justify-end gap-4 mb-4 mr-4">
          <button @click="createButton" class="bg-yellow-600 rounded-full hover:bg-yellow-400 p-2">
            <img src="/plus.png" alt="plus" width="20">
          </button>
         </div>
        <div class=""></div>
        <!-- fetch todo tasks/create -->
         <table class="w-full border-collapse">
          <thead>
            <tr>
              <th class="border p-2 text-center text-xl">#</th>
              <th class="border p-2 text-center text-xl">Tasks</th>
              <th class="border p-2 text-center text-xl">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(undoneTask, index) in undoneTasks" :key="undoneTask.id">
              <td class="border p-2">{{ index + 1 }}.</td>
              <td class="border p-2">{{ undoneTask.task }}</td>
              <td class="border p-2">
                <div class="flex gap-4 items-center justify-center">
                  <button @click="updateTask(undoneTask)" class="bg-green-500 rounded-full p-2 hover:bg-green-300">
                    <img src="/edit.png" alt="edit" width="20">
                  </button>
                  <button @click="deleteTask(undoneTask)" class="bg-red-500 rounded-full p-2 hover:bg-red-300">
                    <img src="/delete.png" alt="delete" width="20">
                  </button>
                </div>
              </td>
            </tr>

            <!-- shiw when no tasks exist -->
             <tr v-if="undoneTasks.length === 0">
              <td colspan="3" class="border p-4 text-center text-gray-500">
                No tasks available.
              </td>
             </tr>
          </tbody>
         </table>
      </div>

      <!-- doing -->
        <div class="bg-white rounded-md shadow-md p-4">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-gray-600 font-bold text-xl text-center">DOING TASKS</h3>
            <span class="bg-blue-600 rounded-full text-white text-sm font-semibold px-3 py-1 shadow">{{ totalDoing }}</span>
          </div>
          <!-- fetch doing tasks -->
           <table class="w-full border-collapse">
            <thead>
              <tr>
                <th class="p-2 text-center border text-xl">#</th>
                <th class="p-2 text-center border text-xl">Tasks</th>
                <th class="p-2 text-center border text-xl">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(doingTask, index) in doingTasks" :key="doingTask.id">
                <td class="p-2 border">{{ index + 1 }}.</td>
                <td class="p-2 border">{{ doingTask.task }}</td>
                <td class="p-2 border">
                  <div class="flex items-center justify-center gap-4">
                    <button @click="updateTask(doingTask)" class="bg-green-500 p-2 rounded-full hover:bg-green-300">
                      <img src="/edit.png" alt="edit" width="20">
                    </button>
                    <button @click="deleteTask(doingTask)" class="bg-red-500 p-2 rounded-full hover:bg-red-300">
                      <img src="/delete.png" alt="delete" width="20">
                    </button>
                  </div>
                </td>
              </tr>

              <!-- show when table is empty -->
               <tr v-if="doingTasks.length === 0">
                <td colspan="3" class="border p-4 text-center text-gray-500">No Items</td>
               </tr>
            </tbody>
           </table>
        </div>

        <!-- done -->
        <div class="bg-white rounded-md shadow-md p-4">
          <div class=" flex items-center justify-between mb-2">
            <h3 class="text-gray-700 font-bold text-xl">DONE TASKS</h3>
            <span class="bg-blue-600 text-white text-sm font-semibold px-3 py-1 rounded-full shadow">{{ totalDone }}</span>
          </div>

          <!-- table for done tasks -->
           <table class="w-full border-collapse">
            <thead>
              <tr>
                <th class="border p-2 text-center text-xl">#</th>
                <th class="border p-2 text-center text-xl">Tasks</th>
                <th class="border p-2 text-center text-xl">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(doneTask, index) in doneTasks" :key="doneTask.id">
                <td class="border p-2">{{ index + 1 }}.</td>
                <td class="border p-2">{{ doneTask.task }}</td>
                <td class="border p-2">
                  <!-- buttons -->
                   <div class="flex items-center justify-center gap-4">
                    <button @click="updateTask(doneTask)" class="bg-green-500 p-2 rounded-full hover:bg-green-300">
                      <img src="/edit.png" alt="edit" width="20">
                    </button>
                    <button @click="deleteTask(doneTask)" class="bg-red-500 p-2 rounded-full hover:bg-red-300">
                      <img src="/delete.png" alt="delete" width="20">
                    </button>
                   </div>
                </td>
              </tr>

              <!-- show when the list is empty -->
               <tr v-if="doneTasks.length === 0">
                <td colspan="3" class="border p-4 text-center text-gray-500">No Items</td>
               </tr>
            </tbody>
           </table>
        </div>
    </div>
  </div>

  <!-- task form -->
   <div v-if="showCreateForm" class="bg-black bg-opacity-50 fixed inset-0 flex items-center justify-center z-50">
    <div class="bg-white rounded-md p-4 w-full max-w-md shadow-md relative">
      <form @submit.prevent="createTask" action="" method="post">

        <!-- close button -->
         <button @click="closeButton" class="absolute right-4 top-2">
          <img src="/close.png" alt="close" width="20">
         </button>
        <h3 class="text-center mb-2 text-xl">{{ task_id ? 'Update Task' : 'Create Task' }}</h3>

        <div class="">
          <label class="block text-xl mb-2" for="task">Task</label>
          <input v-model="task" class="rounded-md p-2 w-full outline-none ring-1 ring-gray-600 hover:ring-blue-600 mb-2" type="text" name="task" id="task">
        </div>

        <div v-if="task_id" class="relative">
        <label class="block text-xl mb-2" for="status">Status</label>
        <select v-model="status" class="rounded-md p-2 w-full outline-none ring-1 ring-gray-500 hover:ring-blue-600 mb-2" name="" id="">
          <option disabled value="">-- Select status --</option>
          <option value="Todo">Todo</option>
          <option value="Doing">Doing</option>
          <option value="Done">Done</option>
        </select>
      </div>
        <div class="">
          <button type="submit" class="w-full mt-2 bg-blue-600 rounded-md p-2 text-white text-xl">{{ task_id ? 'Update' : 'Create' }}</button>
        </div>
      </form>
    </div>
   </div>
</template>

<script>
import api from '@/services/api';

export default {
  data() {
    return {

      changeTodoStatus: false,

      undoneTasks: [],
      doingTasks: [],
      doneTasks: [],

      errors: {},
      task: '',
      status: '',

      task_id: '',

      showCreateForm: false,
    }
  },

  computed: {
    totalUndone(){
      return this.undoneTasks.length
    },

    totalDoing(){
      return this.doingTasks.length
    },

    totalDone(){
      return this.doneTasks.length
    }
  },

  methods: {

    changeTodoStatusButton(){
      this.changeTodoStatus = !this.changeTodoStatus
    },

    async fetchDoneTasks(){
      try {
        const response = await api.get('all_done_tasks')
        this.doneTasks = response.data
        console.log('Successfully fetched done tasks!')
      } catch (error) {
        if (error.response && error.response.data && error.response.data.errors) {
          this.errors = error.response.data.errors
        } else {
          this.errors.general = 'Something went wrong!'
        }
      }
    },

    async fetchDoingTasks(){
      try {
        const response = await api.get('all_doing_tasks')
        this.doingTasks = response.data
        console.log('Successfully fetched doing tasks!')
      } catch (error) {
        if (error.response && error.response.data && error.response.data.errors) {
          this.errors = error.response.data.errors
        } else {
          this.errors.general = 'Something went wrong!'
        }
      }
    },

    closeButton(){
      this.fetchUndoneTasks()
      this.task_id = ''
      this.task = ''
      this.status = ''
      this.showCreateForm = false
    },

    updateTask(taskObject) {
      this.task_id = taskObject.id
      this.showCreateForm = true
      this.task = taskObject.task
      this.status = taskObject.status
    },

    async deleteTask(taskObject){
      const isWindow = window.confirm('Do you want to delete this task?')
      if (isWindow) {
        try {
          this.task_id = taskObject.id
          const response = await api.delete(`delete_task/${this.task_id}`)
          console.log('Task deleted successfully!')
          this.fetchUndoneTasks()
        } catch (error) {
          if (error.response && error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors
          } else {
            this.errors.general = 'Something went wrong!'
          }
        }
      }
    },

    createButton(){
      this.showCreateForm = true
    },

    async createTask(){
      this.errors = {}
      try {
        const payload = {
          task: {
            task: this.task,
            status: this.status
          }
        };
  
        if (this.task_id) {
          const response = await api.patch(`update_task/${this.task_id}`, payload);
          console.log('Task updated successfully!')
          this.task_id = ''
          this.fetchUndoneTasks();
          this.fetchDoingTasks();
          this.fetchDoneTasks();
        } else {
          const response = await api.post('create_task', payload);
          console.log('Task created successfully!')
          this.fetchUndoneTasks();
        }
        
        this.showCreateForm = false
        this.task = ''

      } catch (error) {
        if (error.response && error.response.data && error.response.data.errors) {
          this.errors = error.response.data.errors
        } else {
          this.errors.general = 'Something went wrong!'
        }
      }
    },

    async fetchUndoneTasks(){
      try {
        const response = await api.get('all_undone_tasks')
        this.undoneTasks = response.data
        console.log('Successfully fetch undone tasks!')
      } catch (error) {
        if (error.response && error.response.data && error.response.data.errors) {
          this.errors = error.response.data.errors
        } else {
          this.errors.general = 'Something went wrong!'
        }
      }
    }
  },

  mounted() {
    this.fetchUndoneTasks();
    this.fetchDoingTasks();
    this.fetchDoneTasks();
  }
}
</script>
