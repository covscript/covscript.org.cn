<script setup>
import { ref, computed } from 'vue'
import { useI18n } from 'vue-i18n'
import PageHero from '../components/PageHero.vue'
import CodeBlock from '../components/CodeBlock.vue'

const { t } = useI18n()

const platforms = [
  {
    key: 'windows',
    icon: 'fa-brands fa-windows',
    url: 'https://github.com/covscript/csbuild/releases/download/windows-schedule-release/covscript-windows-x86_64.msi',
    req: t('download_page.win_req'),
    steps: [t('download_page.win_step1'), t('download_page.win_step2'), t('download_page.win_step3'), t('download_page.win_step4')],
  },
  {
    key: 'macos',
    icon: 'fa-brands fa-apple',
    url: 'https://github.com/covscript/csbuild/releases/download/macos-schedule-release/covscript-macos-arm64.dmg',
    req: t('download_page.mac_req'),
    steps: [t('download_page.mac_step1'), t('download_page.mac_step2'), t('download_page.mac_step3'), t('download_page.mac_step4')],
  },
  {
    key: 'ubuntu',
    icon: 'fa-brands fa-ubuntu',
    url: 'https://github.com/covscript/csbuild/releases/download/ubuntu-schedule-release/covscript-ubuntu-x86_64.deb',
    req: t('download_page.ubuntu_req'),
    steps: [t('download_page.ubuntu_step1'), t('download_page.ubuntu_step2'), t('download_page.ubuntu_step3'), t('download_page.ubuntu_step4')],
  },
  {
    key: 'ubuntu_arm',
    icon: 'fa-brands fa-ubuntu',
    url: 'https://github.com/covscript/csbuild/releases/download/ubuntu-arm-schedule-release/covscript-ubuntu-arm64.deb',
    req: t('download_page.ubuntu_arm_req'),
    steps: [t('download_page.ubuntu_step1'), t('download_page.ubuntu_step2'), t('download_page.ubuntu_step3'), t('download_page.ubuntu_step4')],
  },
]

const activeTab = ref(0)
const current = computed(() => platforms[activeTab.value])

const buildCmd = `git clone https://github.com/covscript/covscript.git
cd covscript
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install`
</script>

<template>
  <PageHero :heading="t('download_page.hero_title')" :subtitle="t('download_page.hero_sub')" />

  <section class="section">
    <div class="container">
      <!-- OS Tabs -->
      <div class="tabs">
        <button
          v-for="(p, i) in platforms"
          :key="p.key"
          class="tab"
          :class="{ active: activeTab === i }"
          @click="activeTab = i"
        >
          <i :class="p.icon"></i>
          <span>{{ t(`download_page.tab_${p.key}`) }}</span>
        </button>
      </div>

      <!-- Active Platform Card -->
      <div class="platform-card">
        <div class="card-header">
          <div>
            <h3>{{ t(`download_page.tab_${current.key}`) }}</h3>
            <p class="req">{{ t('download_page.requirements') }}: {{ current.req }}</p>
          </div>
          <a :href="current.url" class="dl-btn" target="_blank" rel="noopener">
            <i class="fa-solid fa-download"></i> {{ t('download_page.download_btn') }}
          </a>
        </div>
        <div class="card-body">
          <h4>{{ t('download_page.install_steps') }}</h4>
          <ol>
            <li v-for="(step, j) in current.steps" :key="j">{{ step }}</li>
          </ol>
        </div>
      </div>

      <!-- Build from Source -->
      <div class="build-section">
        <h3>{{ t('download_page.build_title') }}</h3>
        <p>{{ t('download_page.build_desc') }}</p>
        <CodeBlock :code="buildCmd" language="Shell" />
      </div>
    </div>
  </section>
</template>

<style scoped>
.section { padding: clamp(48px, 8vw, 80px) 0; background: var(--color-bg); }
.container { max-width: 900px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); }

/* OS Tabs */
.tabs { display: flex; gap: 0; margin-bottom: 2rem; border-bottom: 2px solid var(--color-border); }
.tab {
  flex: 1; display: flex; align-items: center; justify-content: center; gap: 8px;
  padding: 16px 12px; background: transparent; border: none;
  border-bottom: 3px solid transparent; margin-bottom: -2px;
  font-size: .9rem; font-weight: 700; color: var(--color-text-secondary);
  cursor: pointer; transition: all .15s; font-family: var(--font-body);
}
.tab:hover { color: var(--color-text); }
.tab.active { color: var(--color-primary-deep); border-bottom-color: var(--color-primary); }

/* Platform Card */
.platform-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
}
.card-header {
  display: flex; align-items: center; justify-content: space-between; gap: 16px;
  padding: 24px 28px; background: rgba(0,196,180,.03);
  border-bottom: 1px solid var(--color-border);
}
.card-header h3 { font-size: 1.2rem; font-weight: 800; color: var(--color-text); }
.req { font-size: .82rem; color: var(--color-text-muted); margin-top: 4px; }
.dl-btn {
  display: inline-flex; align-items: center; gap: 8px; flex-shrink: 0;
  padding: 12px 22px; background: var(--color-primary);
  color: #FFFFFF; border-radius: var(--radius-md);
  font-size: .85rem; font-weight: 800; text-decoration: none;
  transition: background .2s, transform .2s;
}
.dl-btn:hover { background: var(--color-primary-hover); transform: translateY(-1px); }
.card-body { padding: 24px 28px; }
.card-body h4 { font-size: .95rem; font-weight: 800; color: var(--color-text); margin-bottom: 1rem; }
.card-body ol { padding-left: 20px; }
.card-body li {
  font-size: .88rem; color: var(--color-text-secondary);
  line-height: 2; padding-left: 4px;
}

/* Build */
.build-section { margin-top: 3rem; }
.build-section h3 { font-size: 1.3rem; font-weight: 800; color: var(--color-text); margin-bottom: .5rem; }
.build-section p { color: var(--color-text-secondary); font-size: .9rem; margin-bottom: 1.25rem; }

@media (max-width: 768px) {
  .tabs { flex-wrap: wrap; border-bottom: none; gap: 4px; }
  .tab { flex: 1 1 45%; border: 1px solid var(--color-border); border-radius: var(--radius-sm); margin: 0; padding: 12px 8px; font-size: .8rem; }
  .tab.active { border-color: var(--color-primary); background: rgba(0,196,180,.06); }
  .card-header { flex-direction: column; text-align: center; }
  .tab span { display: none; }
}
@media (max-width: 480px) { .tab { flex: 1 1 100%; } .tab span { display: inline; } }
</style>
