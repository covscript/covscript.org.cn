import { createApp } from 'vue'
import { createI18n } from 'vue-i18n'
import App from './App.vue'
import messages from './i18n/index.js'
import './styles/main.css'

// Detect language
function detectLang() {
  const stored = localStorage.getItem('covscript-lang')
  if (stored && ['en', 'zh'].includes(stored)) return stored
  const nav = navigator.language.toLowerCase()
  if (nav.startsWith('zh')) return 'zh'
  return 'en'
}

const i18n = createI18n({
  legacy: false,
  locale: detectLang(),
  fallbackLocale: 'en',
  messages,
})

const app = createApp(App)
app.use(i18n)
app.mount('#app')
