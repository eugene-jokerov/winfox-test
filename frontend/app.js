/*
 * Welcome to your app's main JavaScript file!
 *
 * We recommend including the built version of this JavaScript file
 * (and its CSS file) in your base layout (base.html.twig).
 */

// any CSS you import will output into a single css file (app.css in this case)
import '@formkit/themes/genesis'
import './styles/app.css';
import { createApp } from 'vue'
import SignUpFormComponent from "./vue/controllers/SignUpFormComponent.vue";
import { plugin, defaultConfig } from '@formkit/vue';


createApp(SignUpFormComponent).use(plugin, defaultConfig).mount('#app');
