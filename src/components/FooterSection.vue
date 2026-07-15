<script setup>
import { useI18n } from 'vue-i18n'
const { t } = useI18n()
</script>

<template>
  <footer class="footer">
    <div class="container">
      <div class="footer-grid">
        <div class="footer-col">
          <h4>{{ t('footer.learn') || 'Learn' }}</h4>
          <ul>
            <li><router-link to="/docs">{{ t('nav.docs') || 'Docs' }}</router-link></li>
            <li><router-link to="/playground">{{ t('nav.playground') || 'Playground' }}</router-link></li>
            <li><router-link to="/download">{{ t('nav.download') || 'Download' }}</router-link></li>
          </ul>
        </div>
        <div class="footer-col">
          <h4>{{ t('footer.community_col') || 'Community' }}</h4>
          <ul>
            <li><router-link to="/community">{{ t('nav.community') || 'Community' }}</router-link></li>
            <li><router-link to="/blog">{{ t('nav.blog') || 'Blog' }}</router-link></li>
            <li><a href="https://github.com/covscript" target="_blank" rel="noopener">GitHub</a></li>
          </ul>
        </div>
        <div class="footer-col">
          <h4>{{ t('footer.more') || 'More' }}</h4>
          <ul>
            <li><a href="mailto:dev@unicov.cn">dev@unicov.cn</a></li>
            <li><a href="https://github.com/covscript/covscript" target="_blank" rel="noopener">{{ t('footer.source') || 'Source Code' }}</a></li>
          </ul>
        </div>
      </div>
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
      </div>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  background: var(--color-dark-bg); color: #D6EEEA;
  border-top: 6px solid var(--color-accent);
  padding: clamp(56px, 8vw, 80px) 0 30px;
}
.container { max-width: 1200px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); }

.footer-grid {
  display: grid; grid-template-columns: repeat(3, 1fr);
  gap: clamp(24px, 4vw, 48px);
  margin-bottom: 2.5rem;
  padding-bottom: 2rem;
  border-bottom: 1px solid rgba(255,255,255,0.08);
}
.footer-col h4 {
  font-family: var(--font-body); font-size: .85rem; font-weight: 800;
  color: var(--color-primary); margin-bottom: .75rem;
}
.footer-col ul { list-style: none; }
.footer-col ul li { margin-bottom: .4rem; }
.footer-col ul li a {
  color: rgba(214,238,234,.7); font-size: .82rem;
  transition: color .15s;
}
.footer-col ul li a:hover { color: var(--color-primary); }

.footer-about { max-width: 680px; margin-bottom: 1rem; }
.footer-about h3 { font-family: var(--font-body); font-size: 1.25rem; font-weight: 800; color: #FFFFFF; margin-bottom: .7rem; }
.footer-about p { color: #8EB4B3; font-size: .9rem; line-height: 1.75; }

.powered { text-align: center; color: #7B99A6; font-size: .76rem; margin: 2.5rem 0; font-family: var(--font-code); }
.powered :deep(a) { color: var(--color-primary); text-decoration: none; }
.powered :deep(a:hover) { text-decoration: underline; }

.footer-bottom { padding-top: 20px; border-top: 1px solid rgba(214,238,234,.12); }
.footer-info p { color: #7B99A6; font-size: .78rem; margin-bottom: 3px; }

@media (max-width: 768px) {
  .footer-grid { grid-template-columns: repeat(2, 1fr); }
  .footer-bottom { text-align: center; }
}
@media (max-width: 480px) {
  .footer-grid { grid-template-columns: 1fr; }
}
</style>
