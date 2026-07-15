<script setup>
import { ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import Layout from './components/Layout.vue'

const { locale } = useI18n()

function setLang(lang) {
  locale.value = lang
  localStorage.setItem('covscript-lang', lang)
  document.documentElement.lang = lang === 'zh' ? 'zh-CN' : 'en'
}

// Detect and apply initial lang attribute
const detected = localStorage.getItem('covscript-lang') ||
  (navigator.language.toLowerCase().startsWith('zh') ? 'zh' : 'en')
document.documentElement.lang = detected === 'zh' ? 'zh-CN' : 'en'

// Update document title on route change
watch(() => locale.value, () => {
  // Title will be handled per-page via onMounted
})
</script>

<template>
  <Layout :current-lang="locale" @toggle-lang="setLang(locale === 'zh' ? 'en' : 'zh')" />
</template>

<style>
#app {
  overflow-x: hidden;
}
</style>
