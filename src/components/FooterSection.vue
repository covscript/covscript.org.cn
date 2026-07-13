<script setup>
import { useI18n } from 'vue-i18n'
const { t } = useI18n()
</script>

<template>
  <footer class="footer">
    <div class="container">
      <div class="footer-about">
        <h3>{{ t('about.heading') }}</h3>
        <p>{{ t('about.text') }}</p>
      </div>
      <p class="powered" v-html="t('footer.powered')"></p>
      <div class="footer-bottom">
        <div class="footer-info">
          <p>{{ t('footer.copyright') }}</p>
          <p>{{ t('footer.license') }}</p>
        </div>
        <div class="footer-links">
          <a href="https://github.com/covscript" target="_blank" rel="noopener">GitHub</a>
          <a href="mailto:dev@unicov.cn">dev@unicov.cn</a>
        </div>
      </div>
    </div>
  </footer>
</template>

<style scoped>
.footer { background: #102a43; color: #d6eeea; border-top: 4px solid #ef7b4a; padding: clamp(48px, 8vw, 76px) 0 30px; }
.container { max-width: 1200px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); }
.powered { text-align: center; color: #94b9b7; font-size: .76rem; margin: 2.5rem 0; font-family: 'DM Mono', monospace; }
.powered :deep(a) { color: #65d5c8; text-decoration: none; }
.powered :deep(a:hover) { text-decoration: underline; }
.footer-about { max-width: 680px; margin-bottom: 1rem; }
.footer-about h3 { font-family: Manrope, sans-serif; font-size: 1.25rem; font-weight: 800; color: #fff; margin-bottom: .7rem; }
.footer-about p { color: #a9c6c5; font-size: .9rem; line-height: 1.75; }
.footer-bottom { display: flex; justify-content: space-between; align-items: end; flex-wrap: wrap; gap: 16px; padding-top: 20px; border-top: 1px solid rgba(214,238,234,.16); }
.footer-info p { color: #94b9b7; font-size: .78rem; margin-bottom: 3px; }
.footer-links { display: flex; gap: 20px; }
.footer-links a { color: #d6eeea; font-size: .8rem; font-weight: 700; text-decoration: none; transition: color .15s; }
.footer-links a:hover { color: #65d5c8; }
@media (max-width: 768px) { .footer-bottom { flex-direction: column; text-align: center; } }
</style>
