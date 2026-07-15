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
    <router-link to="/" class="nav-logo" @click="closeMenu">
      <img :src="logoUrl" alt="CovScript" class="nav-logo-img" />
    </router-link>
    <ul class="nav-links" :class="{ open: menuOpen }">
      <li><router-link to="/docs" @click="closeMenu">{{ t('nav.docs') }}</router-link></li>
      <li><router-link to="/playground" @click="closeMenu">{{ t('nav.playground') }}</router-link></li>
      <li><router-link to="/download" @click="closeMenu">{{ t('nav.download') }}</router-link></li>
      <li><router-link to="/community" @click="closeMenu">{{ t('nav.community') }}</router-link></li>
      <li><router-link to="/blog" @click="closeMenu">{{ t('nav.blog') }}</router-link></li>
      <li>
        <button class="lang-toggle" type="button" :aria-label="currentLang === 'zh' ? 'Switch to English' : '切换至中文'" @click="emit('toggleLang')">
          {{ currentLang === 'zh' ? 'EN' : '中' }}
        </button>
      </li>
      <li class="cta-item">
        <router-link to="/playground" class="nav-cta" @click="closeMenu">{{ t('nav.try_now') }}</router-link>
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
  background: rgba(250,252,251,.78); backdrop-filter: blur(16px);
  border-bottom: 1px solid transparent;
  transition: background .3s, border .3s, box-shadow .3s;
}
.navbar.scrolled {
  background: rgba(250,252,251,.96);
  border-bottom-color: var(--color-border);
  box-shadow: var(--shadow-sm);
}
.nav-logo { display: flex; align-items: center; text-decoration: none; z-index: 1001; }
.nav-logo-img { height: 34px; width: auto; }
.nav-links { display: flex; align-items: center; gap: 24px; list-style: none; }

.nav-links a {
  color: var(--color-text-secondary); font-size: .84rem; font-weight: 700;
  text-decoration: none; transition: color .15s; position: relative;
}
.nav-links a::after {
  content: ''; position: absolute; bottom: -4px; left: 0; right: 0; height: 2px;
  background: var(--color-primary); transform: scaleX(0); transition: transform .15s;
}
.nav-links a:hover { color: var(--color-text); }
.nav-links a:hover::after { transform: scaleX(1); }

/* vue-router active state */
.nav-links a.router-link-active { color: var(--color-primary-deep); }
.nav-links a.router-link-active::after { transform: scaleX(1); background: var(--color-primary); }

.lang-toggle {
  background: transparent; border: 1px solid var(--color-border);
  color: var(--color-text-secondary); min-width: 42px; height: 30px;
  border-radius: var(--radius-md); cursor: pointer;
  font-size: .75rem; font-weight: 800; transition: all .15s;
}
.lang-toggle:hover { background: rgba(0,196,180,.08); color: var(--color-primary-deep); border-color: var(--color-primary); }

/* CTA button */
.cta-item { margin-left: 4px; }
.nav-cta {
  display: inline-flex; align-items: center; justify-content: center;
  background: var(--color-primary); color: #FFFFFF !important;
  min-height: 34px; padding: 6px 16px; border-radius: var(--radius-md);
  font-size: .8rem !important; font-weight: 800;
  transition: background .2s, transform .2s, box-shadow .2s !important;
}
.nav-cta::after { display: none !important; }
.nav-cta:hover { background: var(--color-primary-hover); transform: translateY(-1px); box-shadow: var(--shadow-glow); }
.nav-cta.router-link-active { color: #FFFFFF !important; }

.menu-toggle { display: none; background: none; border: 1px solid var(--color-border); border-radius: var(--radius-md); color: var(--color-text); cursor: pointer; font-size: .76rem; font-weight: 800; min-width: 52px; height: 32px; }

@media (max-width: 768px) {
  .navbar { height: 60px; }
  .nav-logo-img { height: 27px; }
  .nav-links {
    position: fixed; top: 60px; left: 0; right: 0;
    background: rgba(250,252,251,.98); backdrop-filter: blur(20px);
    flex-direction: column; gap: 0; padding: 12px 0;
    border-bottom: 1px solid var(--color-border);
    transform: translateY(-100%); opacity: 0; pointer-events: none;
    transition: .3s;
  }
  .nav-links.open { transform: translateY(0); opacity: 1; pointer-events: auto; }
  .nav-links li { width: 100%; }
  .nav-links a { display: block; padding: 13px 24px; font-size: .95rem; }
  .nav-links a::after { display: none; }
  .lang-toggle { margin: 8px 24px; }
  .cta-item { margin: 8px 24px; }
  .nav-cta { width: 100%; text-align: center; justify-content: center; }
  .menu-toggle { display: block; }
}
</style>
