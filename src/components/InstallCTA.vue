<script setup>
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import SectionLabel from './SectionLabel.vue'

const { t } = useI18n()

const activeOS = ref('windows')
const copied = ref(false)

const commands = {
  windows: 'winget install CovScript.CovScript',
  macos: 'brew install covscript/tap/covscript',
  ubuntu: 'sudo dpkg -i covscript-ubuntu-x86_64.deb',
}

async function copyCmd() {
  try {
    await navigator.clipboard.writeText(commands[activeOS.value])
    copied.value = true
    setTimeout(() => { copied.value = false }, 2000)
  } catch { /* */ }
}
</script>

<template>
  <section class="section">
    <div class="container">
      <SectionLabel :text="t('install.label') || 'Quick Install'" />
      <h2>{{ t('install.heading') || 'Get CovScript in Seconds' }}</h2>
      <div class="install-card">
        <div class="os-tabs">
          <button
            v-for="os in ['windows', 'macos', 'ubuntu']"
            :key="os"
            class="os-tab"
            :class="{ active: activeOS === os }"
            @click="activeOS = os"
          >
            <i v-if="os === 'windows'" class="fa-brands fa-windows"></i>
            <i v-else-if="os === 'macos'" class="fa-brands fa-apple"></i>
            <i v-else class="fa-brands fa-ubuntu"></i>
            <span>{{ os === 'windows' ? 'Windows' : os === 'macos' ? 'macOS' : 'Ubuntu' }}</span>
          </button>
        </div>
        <div class="cmd-line">
          <code>{{ commands[activeOS] }}</code>
          <button class="cmd-copy" @click="copyCmd">{{ copied ? 'Copied!' : 'Copy' }}</button>
        </div>
      </div>
      <p class="cta-link">
        <router-link to="/download">{{ t('install.view_all') || 'View all downloads and install guides →' }}</router-link>
      </p>
    </div>
  </section>
</template>

<style scoped>
.section { padding: clamp(72px, 10vw, 110px) 0; background: var(--color-bg); }
.container { max-width: 780px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); text-align: center; }

h2 {
  font-family: var(--font-body); font-size: clamp(1.9rem, 4vw, 2.75rem);
  font-weight: 800; margin-bottom: 2.5rem; color: var(--color-text);
}

.install-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  overflow: hidden;
  box-shadow: var(--shadow-md);
}

.os-tabs {
  display: flex; gap: 0;
  border-bottom: 1px solid var(--color-border);
  background: rgba(0,0,0,.01);
}
.os-tab {
  flex: 1; display: flex; align-items: center; justify-content: center; gap: 8px;
  padding: 14px 10px; background: transparent; border: none;
  border-bottom: 2px solid transparent;
  font-size: .85rem; font-weight: 700; color: var(--color-text-secondary);
  cursor: pointer; transition: all .15s;
  font-family: var(--font-body);
}
.os-tab:hover { color: var(--color-text); }
.os-tab.active {
  color: var(--color-primary-deep);
  border-bottom-color: var(--color-primary);
  background: rgba(0,196,180,.03);
}

.cmd-line {
  display: flex; align-items: center; gap: 12px;
  padding: 20px 24px;
  background: var(--color-code-bg);
}
.cmd-line code {
  flex: 1; font-family: var(--font-code); font-size: .88rem;
  color: var(--color-code-text); user-select: all;
}
.cmd-copy {
  flex-shrink: 0; min-height: 36px; padding: 6px 16px;
  background: var(--color-primary); color: var(--color-dark-bg);
  border: none; border-radius: var(--radius-md);
  font-size: .78rem; font-weight: 800; cursor: pointer;
  transition: background .15s;
}
.cmd-copy:hover { background: var(--color-primary-hover); }

.cta-link { margin-top: 1.5rem; }
.cta-link a { color: var(--color-primary-deep); font-weight: 700; font-size: .9rem; }
.cta-link a:hover { color: var(--color-primary); }

@media (max-width: 600px) {
  .os-tab span { display: none; }
  .os-tab { font-size: 1.2rem; padding: 12px 8px; }
  .cmd-line { flex-direction: column; gap: 10px; }
  .cmd-line code { font-size: .78rem; word-break: break-all; }
  .cmd-copy { width: 100%; }
}
</style>
