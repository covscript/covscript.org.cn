<script setup>
import { useI18n } from 'vue-i18n'
import PageHero from '../components/PageHero.vue'

const { t } = useI18n()

const contributeSteps = [
  { num: '01', titleKey: 'community_page.step1_title', descKey: 'community_page.step1_desc' },
  { num: '02', titleKey: 'community_page.step2_title', descKey: 'community_page.step2_desc' },
  { num: '03', titleKey: 'community_page.step3_title', descKey: 'community_page.step3_desc' },
  { num: '04', titleKey: 'community_page.step4_title', descKey: 'community_page.step4_desc' },
]

const channels = [
  { icon: 'fa-brands fa-github', titleKey: 'community_page.github_discussions', descKey: 'community_page.github_discussions_desc', href: 'https://github.com/orgs/covscript/discussions' },
  { icon: 'fa-solid fa-envelope', titleKey: 'community_page.email', descKey: 'community_page.email_desc', href: 'mailto:dev@unicov.cn' },
  { icon: 'fa-brands fa-weixin', titleKey: 'community_page.wechat', descKey: 'community_page.wechat_desc', href: '#' },
]
</script>

<template>
  <PageHero :heading="t('community_page.hero_title')" :subtitle="t('community_page.hero_sub')" />

  <!-- Contribute -->
  <section class="section">
    <div class="container">
      <h2 class="section-title">{{ t('community_page.contribute') }}</h2>
      <p class="section-desc">{{ t('community_page.contribute_desc') }}</p>
      <div class="steps-grid">
        <div v-for="step in contributeSteps" :key="step.num" class="step-card">
          <span class="step-num">{{ step.num }}</span>
          <h3>{{ t(step.titleKey) }}</h3>
          <p>{{ t(step.descKey) }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- Channels -->
  <section class="section alt">
    <div class="container">
      <h2 class="section-title">{{ t('community_page.channels') }}</h2>
      <div class="channels-grid">
        <a
          v-for="ch in channels"
          :key="ch.titleKey"
          :href="ch.href"
          class="channel-card"
          target="_blank"
          rel="noopener"
        >
          <span class="ch-icon"><i :class="ch.icon"></i></span>
          <div>
            <h3>{{ t(ch.titleKey) }}</h3>
            <p>{{ t(ch.descKey) }}</p>
          </div>
        </a>
      </div>
    </div>
  </section>

  <!-- Code of Conduct -->
  <section class="section">
    <div class="container coc">
      <h2>{{ t('community_page.code_of_conduct') }}</h2>
      <p>{{ t('community_page.coc_text') }}</p>
    </div>
  </section>
</template>

<style scoped>
.section { padding: clamp(48px, 8vw, 80px) 0; background: var(--color-bg); }
.section.alt { background: var(--color-surface); }
.container { max-width: 1000px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); }

.section-title { font-size: 1.9rem; font-weight: 800; color: var(--color-text); margin-bottom: .75rem; }
.section-desc { color: var(--color-text-secondary); font-size: .95rem; max-width: 640px; margin-bottom: 2.5rem; }

/* Steps */
.steps-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1px; background: var(--color-border); border: 1px solid var(--color-border); border-radius: var(--radius-sm); overflow: hidden; }
.step-card {
  background: var(--color-surface); padding: 28px 20px;
  transition: transform .2s, box-shadow .2s;
}
.step-card:hover { transform: translateY(-2px); box-shadow: var(--shadow-sm); }
.step-num { display: block; font-family: var(--font-display); font-size: 2rem; color: var(--color-primary); margin-bottom: .5rem; }
.step-card h3 { font-size: .95rem; font-weight: 800; color: var(--color-text); margin-bottom: .35rem; }
.step-card p { font-size: .82rem; color: var(--color-text-secondary); line-height: 1.6; }

/* Channels */
.channels-grid { display: flex; flex-direction: column; gap: 1px; background: var(--color-border); border: 1px solid var(--color-border); border-radius: var(--radius-sm); overflow: hidden; }
.channel-card {
  display: flex; align-items: center; gap: 18px;
  padding: 22px 24px; background: var(--color-bg);
  text-decoration: none; color: inherit;
  transition: background .2s;
}
.channel-card:hover { background: #F8FDFC; }
.ch-icon { font-size: 1.5rem; width: 36px; text-align: center; color: var(--color-primary-deep); flex-shrink: 0; }
.channel-card h3 { font-size: .95rem; font-weight: 800; color: var(--color-text); margin-bottom: 2px; }
.channel-card p { font-size: .8rem; color: var(--color-text-secondary); }

.coc { max-width: 700px; text-align: center; }
.coc h2 { font-size: 1.5rem; font-weight: 800; color: var(--color-text); margin-bottom: .75rem; }
.coc p { color: var(--color-text-secondary); font-size: .9rem; line-height: 1.75; }

@media (max-width: 768px) { .steps-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 480px) { .steps-grid { grid-template-columns: 1fr; } }
</style>
