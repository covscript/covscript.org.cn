<script setup>
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import logoUrl from '../assets/logo.png'

defineProps({ currentLang: String })
const emit = defineEmits(['toggleLang'])
const { t } = useI18n()

const menuOpen = ref(false)
const scrolled = ref(false)

function toggleMenu() { menuOpen.value = !menuOpen.value }
function closeMenu() { menuOpen.value = false }

if (typeof window !== 'undefined') {
  window.addEventListener('scroll', () => { scrolled.value = window.scrollY > 20 }, { passive: true })
}
</script>

<template>
  <nav class="navbar" :class="{ scrolled }">
    <a href="#" class="nav-logo" @click="closeMenu">
      <img :src="logoUrl" alt="CovScript" class="nav-logo-img" />
    </a>
    <ul class="nav-links" :class="{ open: menuOpen }">
      <li><a href="#features" @click="closeMenu">{{ t('nav.features') }}</a></li>
      <li><a href="#playground" @click="closeMenu">{{ t('nav.playground') }}</a></li>
      <li><a href="#quickstart" @click="closeMenu">{{ t('nav.download') }}</a></li>
      <li>
        <button class="lang-toggle" type="button" :aria-label="currentLang === 'zh' ? 'Switch to English' : '切换至中文'" @click="emit('toggleLang')">
          {{ currentLang === 'zh' ? 'EN' : '中' }}
        </button>
      </li>
    </ul>
    <button class="menu-toggle" type="button" :aria-label="menuOpen ? 'Close menu' : 'Open menu'" :aria-expanded="menuOpen" @click="toggleMenu">{{ menuOpen ? '×' : 'Menu' }}</button>
  </nav>
</template>

<style scoped>
.navbar {
  position: fixed; top: 0; left: 0; right: 0; height: 72px; z-index: 1000;
  display: flex; align-items: center; justify-content: space-between;
  padding: 0 clamp(20px, 5vw, 80px);
  background: rgba(247,250,249,.78); backdrop-filter: blur(16px);
  border-bottom: 1px solid transparent;
  transition: background .3s, border .3s, box-shadow .3s;
}
.navbar.scrolled {
  background: rgba(247,250,249,.96);
  border-bottom-color: #d9e6e3;
  box-shadow: 0 4px 24px rgba(17,43,59,.06);
}
.nav-logo { display: flex; align-items: center; text-decoration: none; }
.nav-logo-img { height: 34px; width: auto; }
.nav-links { display: flex; align-items: center; gap: 28px; list-style: none; }
.nav-links a {
  color: #486581; font-size: .84rem; font-weight: 700; text-decoration: none;
  transition: color .15s; position: relative;
}
.nav-links a::after {
  content: ''; position: absolute; bottom: -4px; left: 0; right: 0; height: 2px;
  background: #12b7a8; transform: scaleX(0); transition: transform .15s;
}
.nav-links a:hover { color: #102a43; }
.nav-links a:hover::after { transform: scaleX(1); }
.lang-toggle {
  background: transparent; border: 1px solid #b8cbc7;
  color: #24545c; min-width: 42px; height: 30px; border-radius: 5px; cursor: pointer;
  font-size: .75rem; font-weight: 800; transition: all .15s;
}
.lang-toggle:hover { background: #e1f5f1; color: #087f74; border-color: #12b7a8; }
.menu-toggle { display: none; background: none; border: 1px solid #b8cbc7; border-radius: 5px; color: #102a43; cursor: pointer; font-size: .76rem; font-weight: 800; min-width: 52px; height: 32px; }

@media (max-width: 768px) {
  .navbar { height: 60px; }
  .nav-logo-img { height: 27px; }
  .nav-links {
    position: fixed; top: 60px; left: 0; right: 0;
    background: rgba(247,250,249,.98); backdrop-filter: blur(20px);
    flex-direction: column; gap: 0; padding: 12px 0;
    border-bottom: 1px solid #d9e6e3;
    transform: translateY(-100%); opacity: 0; pointer-events: none;
    transition: .3s;
  }
  .nav-links.open { transform: translateY(0); opacity: 1; pointer-events: auto; }
  .nav-links li { width: 100%; }
  .nav-links a { display: block; padding: 13px 24px; font-size: .95rem; }
  .nav-links a::after { display: none; }
  .lang-toggle { margin: 8px 24px; }
  .menu-toggle { display: block; }
}
</style>
