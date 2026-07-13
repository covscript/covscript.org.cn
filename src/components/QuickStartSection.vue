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
    </div>
  </section>
</template>

<style scoped>
.section { padding: clamp(72px, 10vw, 120px) 0; background: #fff; }
.container { max-width: 1200px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); }
.label { display: inline-block; font-family: 'DM Mono', monospace; font-size: .72rem; font-weight: 500; color: #087f74; text-transform: uppercase; letter-spacing: .1em; margin-bottom: 1rem; padding: 3px 0; border-bottom: 2px solid #ef7b4a; }
.title { font-family: Manrope, sans-serif; font-size: clamp(1.9rem, 4vw, 2.75rem); font-weight: 800; margin-bottom: .75rem; color: #102a43; }
.subtitle { color: #526f7a; font-size: .95rem; max-width: 560px; }
.dl-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1px; background: #d9e6e3; border: 1px solid #d9e6e3; margin-top: 2rem; }
.dl-card {
  background: #fff; padding: 28px 24px; display: flex; align-items: center; gap: 18px;
  text-decoration: none; color: inherit; transition: background .2s;
}
.dl-card:hover { background: #f5fbfa; }
.dl-icon { font-size: 1.75rem; width: 40px; text-align: center; flex-shrink: 0; color: #486581; }
.dl-name { display: block; font-family: Manrope, sans-serif; font-weight: 800; font-size: .95rem; color: #102a43; margin-bottom: 2px; }
.dl-desc { display: block; font-size: .8rem; color: #79969e; }
@media (max-width: 600px) { .dl-grid { grid-template-columns: 1fr; } }
</style>
