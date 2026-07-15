<script setup>
import { useI18n } from 'vue-i18n'; const { t } = useI18n()

const downloads = [
  { os: 'windows',    url: 'https://github.com/covscript/csbuild/releases/download/windows-schedule-release/covscript-windows-x86_64.msi' },
  { os: 'macos',      url: 'https://github.com/covscript/csbuild/releases/download/macos-schedule-release/covscript-macos-arm64.dmg' },
  { os: 'ubuntu',     url: 'https://github.com/covscript/csbuild/releases/download/ubuntu-schedule-release/covscript-ubuntu-x86_64.deb' },
  { os: 'ubuntu_arm', url: 'https://github.com/covscript/csbuild/releases/download/ubuntu-arm-schedule-release/covscript-ubuntu-arm64.deb' },
]
</script>

<template>
  <section class="section" id="quickstart">
    <div class="container">
      <span class="label">Download</span>
      <h2 class="title">{{ t('quickstart.heading') }}</h2>
      <p class="subtitle">{{ t('quickstart.desc') }}</p>
      <div class="dl-grid">
        <a
          v-for="d in downloads"
          :key="d.os"
          :href="d.url"
          class="dl-card"
          target="_blank"
          rel="noopener"
        >
          <span class="dl-icon">
            <i v-if="d.os === 'windows'" class="fa-brands fa-windows"></i>
            <i v-else-if="d.os === 'macos'" class="fa-brands fa-apple"></i>
            <i v-else class="fa-brands fa-ubuntu"></i>
          </span>
          <div>
            <span class="dl-name">{{ t(`quickstart.${d.os}`) }}</span>
            <span class="dl-desc">{{ t(`quickstart.${d.os}_desc`) }}</span>
          </div>
        </a>
      </div>
      <p class="view-all">
        <router-link to="/download">{{ t('quickstart.view_all') || 'View all downloads →' }}</router-link>
      </p>
    </div>
  </section>
</template>

<style scoped>
.section { padding: clamp(72px, 10vw, 120px) 0; background: var(--color-surface); }
.container { max-width: 1200px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); }
.label { display: inline-block; font-family: var(--font-code); font-size: .72rem; font-weight: 500; color: var(--color-primary-deep); text-transform: uppercase; letter-spacing: .1em; margin-bottom: 1rem; padding: 3px 0; border-bottom: 3px solid var(--color-accent); }
.title { font-family: var(--font-body); font-size: clamp(1.9rem, 4vw, 2.75rem); font-weight: 800; margin-bottom: .75rem; color: var(--color-text); }
.subtitle { color: var(--color-text-secondary); font-size: .95rem; max-width: 560px; }
.dl-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1px; background: var(--color-border); border: 1px solid var(--color-border); border-radius: var(--radius-sm); overflow: hidden; margin-top: 2rem; }
.dl-card {
  background: var(--color-surface); padding: 28px 24px; display: flex; align-items: center; gap: 18px;
  text-decoration: none; color: inherit; transition: background .2s, transform .2s;
}
.dl-card:hover { background: #F8FDFC; transform: translateY(-2px); }
.dl-icon { font-size: 1.75rem; width: 40px; text-align: center; flex-shrink: 0; color: var(--color-text-secondary); }
.dl-name { display: block; font-family: var(--font-body); font-weight: 800; font-size: .95rem; color: var(--color-text); margin-bottom: 2px; }
.dl-desc { display: block; font-size: .8rem; color: var(--color-text-muted); }
.view-all { text-align: center; margin-top: 2rem; }
.view-all a { color: var(--color-primary-deep); font-weight: 700; font-size: .9rem; transition: color .15s; }
.view-all a:hover { color: var(--color-primary); }
@media (max-width: 600px) { .dl-grid { grid-template-columns: 1fr; } }
</style>
