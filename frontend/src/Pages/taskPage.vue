
<template>
    <div class="page-template bg-gray-400 h-screen flex justify-center p-4">
        <div class="task-page bg-gray-200 w-full p-4 rounded-md shadow-md">
            <h3 class="text-center font-bold text-transparent bg-clip-text bg-gradient-to-r from-blue-300 to-blue-900">MY-TASKS</h3>
            <div class="main-container flex items-stretch justify-between w-full flex-col md:flex-row gap-4 mt-4">
                <!-- TO-DO Column -->
                <div class="bg-white p-4 rounded-lg shadow-md flex-1 min-w-0 break-words">
                    <p class="text-center text-lg font-bold text-gray-700 mb-4 border-b pb-2">
                        TO-DO TASKS
                        <span class="text-sm font-normal">({{ todoTasks.length }})</span>
                    </p>

                    <div class="flex justify-end mb-2">
                        <button @click="openModal = true" class="bg-blue-400 text-white rounded-md px-4 py-2">
                            Add Task
                        </button>
                    </div>

                    <draggable 
                        v-model="todoTasks" 
                        group="tasks" 
                        item-key="id"
                        @end="onDragEnd"
                        class="space-y-3"
                    >
                        <template #item="{ element: task, index }">
                            <div :data-id="task.id" class="flex items-center justify-between bg-yellow-100 border border-yellow-300 rounded-md px-3 py-2 hover:shadow-sm transition">
                                <div class="text-sm font-bold text-yellow-700 bg-yellow-300 w-6 h-6 flex items-center justify-center rounded-full">
                                    {{ index + 1 }}
                                </div>
                                <div class="flex justify-between items-center w-full ml-3">
                                    <div class="text-sm text-gray-800">
                                        {{ task.task }}
                                    </div>
                                    <div class="flex gap-2">
                                        <button @click.stop="singleTask(task.id, task.task)" class="hover:scale-110 transition-transform">
                                            <img src="/edit.png" alt="edit" width="16" height="16" />
                                        </button>
                                        <button @click.stop="deleteTasks(task.id)" class="hover:scale-110 transition-transform">
                                            <img src="/delete.png" alt="delete" width="16" height="16" />
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </draggable>
                </div>

                <!-- DOING Column -->
                <div class="bg-white p-4 rounded-lg shadow-md flex-1 min-w-0 break-words">
                    <p class="text-center text-lg font-bold text-gray-700 mb-4 border-b pb-2">
                        DOING TASKS
                        <span class="text-sm font-normal">({{ doingTasks.length }})</span>
                    </p>
                    <draggable 
                        v-model="doingTasks" 
                        group="tasks" 
                        item-key="id"
                        @end="onDragEnd"
                        class="space-y-3"
                    >
                        <template #item="{ element: task, index }">
                            <div :data-id="task.id" class="flex items-center justify-between bg-blue-100 border border-blue-300 rounded-md px-3 py-2 hover:shadow-sm transition">
                                <div class="text-sm font-bold text-blue-700 bg-blue-300 w-6 h-6 flex items-center justify-center rounded-full">
                                    {{ index + 1 }}
                                </div>
                                <div class="flex justify-between items-center w-full ml-3">
                                    <div class="text-sm text-gray-800">
                                        {{ task.task }}
                                    </div>
                                    <div class="flex gap-2">
                                        <button @click.stop="singleTask(task.id, task.task)" class="hover:scale-110 transition-transform">
                                            <img src="/edit.png" alt="edit" width="16" height="16" />
                                        </button>
                                        <button @click.stop="deleteTasks(task.id)" class="hover:scale-110 transition-transform">
                                            <img src="/delete.png" alt="delete" width="16" height="16" />
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </draggable>
                </div>

                <!-- DONE Column -->
                <div class="bg-white p-4 rounded-lg shadow-md flex-1 min-w-0 break-words">
                    <p class="text-center text-lg font-bold text-gray-700 mb-4 border-b pb-2">
                        DONE TASKS
                        <span class="text-sm font-normal">({{ doneTasks.length }})</span>
                    </p>
                    <draggable 
                        v-model="doneTasks" 
                        group="tasks" 
                        item-key="id"
                        @end="onDragEnd"
                        class="space-y-3"
                    >
                        <template #item="{ element: task, index }">
                            <div :data-id="task.id" class="flex items-center justify-between bg-green-100 border border-green-300 rounded-md px-3 py-2 hover:shadow-sm transition">
                                <div class="text-sm font-bold text-green-700 bg-green-300 w-6 h-6 flex items-center justify-center rounded-full">
                                    {{ index + 1 }}
                                </div>
                                <div class="flex justify-between items-center w-full ml-3">
                                    <div class="text-sm text-gray-800">
                                        {{ task.task }}
                                    </div>
                                    <div class="flex gap-2">
                                        <button @click.stop="singleTask(task.id, task.task)" class="hover:scale-110 transition-transform">
                                            <img src="/edit.png" alt="edit" width="16" height="16" />
                                        </button>
                                        <button @click.stop="deleteTasks(task.id)" class="hover:scale-110 transition-transform">
                                            <img src="/delete.png" alt="delete" width="16" height="16" />
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </draggable>
                </div>
            </div>
        </div>

        <!-- create task modal -->
     
     <!-- Modal Overlay -->
      <div v-if="openModal" class="bg-black opacity-40 fixed inset-0 flex justify-center items-center">

        <!-- Modal Box -->
         <div v-if="openModal" class="bg-white p-6 w-full max-w-sm rounded-lg shadow-lg">
            <h3 class="text-center text-green-700 text-lg font-bold mb-4">{{ isEdit ? 'Update Task' : 'Create Task' }}</h3>
            <input
             type="text" 
             placeholder="Add task here..." 
             v-model="task" 
             class="outline-none border border-red-600 rounded-md p-2 w-full mb-3 focus:ring-blue-400" 
             required 
             />
            <p v-if="errors.name" class="text-red-400 text-sm mb-2">{{ errors.name }}</p>

            <!-- buttons -->
             <div class="flex justify-end gap-4">
                <button @click="cancelButton" type="button" class="bg-yellow-500 px-4 py-2 rounded-md">
                    Cancel
                </button>
                <button
                 @click="submitTask" 
                 type="submit" 
                 class="bg-blue-500 px-4 py-2 rounded-md"
                 :disabled="loading"
                 >

                 <!-- when not loading -->
                  <span v-if="!loading">{{ isEdit ? "Update" : "Create" }}</span>

                  <!-- while loading -->
                   <span v-else class="flex items-center gap-2">
                    <svg class="animate-spin h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                    </svg>
                    Saving...
                   </span>
                </button>
             </div>
         </div>
      </div>
    </div>
</template>

<script>
import draggable from 'vuedraggable';
import api from '@/services/api';
import { setupTokenTimers } from '@/services/auth';

export default {
    components: {
        draggable
    },

    mounted() {
        setupTokenTimers();
        this.fetchTasks();
    },

    data() {
        return {
            tasks: [],
            errors: {},
            task: '',
            openModal: false,
            isEdit: false,
            taskId: null,
            
            loading: false
        }
    },

    computed: {

        todoTasks: {
            get() {
                return this.tasks.filter(task => task.status === 'todo');
            },
            set(value) {
                // This setter is needed for v-model to work with draggable
            }
        },

        doingTasks: {
            get() {
                return this.tasks.filter(task => task.status === 'doing');
            },
            set(value) {
                // this.updateTasksOrder(value, 'doing');
            }
        },

        doneTasks: {
            get() {
                return this.tasks.filter(task => task.status === 'done');
            },
            set(value) {
                // this.updateTasksOrder(value, 'done');
            }
        },
    },
     
    methods: {
        async onDragEnd(evt) {
            try {
                const taskId = parseInt(evt.item?.dataset?.id);
                if (!taskId) return;

                const movedTask = this.tasks.find(task => task.id === taskId);
                if (!movedTask) return;

                const targetColumn = evt.to.closest('.bg-white');
                let newStatus = 'todo';
                const headerText = targetColumn?.querySelector('p')?.textContent?.toUpperCase() || '';

                if (headerText.includes('DOING')) newStatus = 'doing';
                else if (headerText.includes('DONE')) newStatus = 'done';

                // Prevent unnecessary update
                if (movedTask.status === newStatus) return;

                // ✅ Update local task status
                movedTask.status = newStatus;

                // ✅ Send update to backend
                await api.patch(`update_task/${taskId}`, {
                task: { status: newStatus }
                });

                // ✅ Refresh tasks from backend
                await this.fetchTasks();

            } catch (error) {
                console.error('Drag error:', error);
                alert('Failed to update task');
                await this.fetchTasks(); // fallback recovery
            }
        },

        // viewSingleTask
        async singleTask(id) {
            try {
                const response = await api.get(`single_task/${id}`);
                const data = response.data

                this.task = data.task;
                this.taskId = id;
                this.isEdit = true;
                this.openModal = true;
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors = { general: "Something went went"}
                }
            }
        },

        // deleteTasks
        async deleteTasks(id) {
            await api.delete(`delete_task/${id}`)
            this.fetchTasks()
        },

        // cancelButtton
        cancelButton () {
            this.task = '';
            this.fetchTasks();
            this.openModal = false;
            this.errors = '';
            this.isEdit = false;
            this.taskId = null;
        },

        // create_task
        async submitTask () {

            this.loading = true;
            
            try {
                const payload = {
                    task: {
                        name: this.task
                    }
                }

                if (this.isEdit && this.taskId) {
                    // update Task
                    await api.patch(`update_task/${this.taskId}`, payload)
                    // alert("Task Updated")
                } else {
                    await api.post('create_task', payload)
                    // alert("Task Created")
                }

                this.task = '';
                this.openModal = false;
                this.isEdit = false;
                this.taskId = null;
                this.errors = {};
                
                this.fetchTasks();
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors = { general: "Something went wrong"}
                }
            } finally {
                this.loading = false;
            }
        },

        // fetch tasks
        async fetchTasks() {
            try {
                const response = await api.get('all_tasks')
                this.tasks = response.data
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors = { general: "Something went wrong!"}
                }
            }
        }
    }
}
</script>
