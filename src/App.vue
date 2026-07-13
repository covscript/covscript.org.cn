<script setup>
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import NavBar from './components/NavBar.vue'
import HeroSection from './components/HeroSection.vue'
import FeaturesSection from './components/FeaturesSection.vue'
import PlaygroundSection from './components/PlaygroundSection.vue'
import QuickStartSection from './components/QuickStartSection.vue'
import FooterSection from './components/FooterSection.vue'

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
</script>

<template>
  <NavBar :current-lang="locale" @toggle-lang="setLang(locale === 'zh' ? 'en' : 'zh')" />
  <HeroSection />
  <FeaturesSection />
  <PlaygroundSection />
  <QuickStartSection />
  <FooterSection />
</template>

<style>
#app {
  overflow-x: hidden;
}
</style>
