<script setup>
import { useI18n } from 'vue-i18n'
import SectionLabel from './SectionLabel.vue'

const { t } = useI18n()

// Static data (can be replaced with GitHub API fetch later)
const stats = [
  { value: '350+', label: 'GitHub Stars' },
  { value: '20+', label: 'Contributors' },
  { value: '100+', label: 'Releases' },
]
</script>

<template>
  <section class="section">
    <div class="container">
      <SectionLabel :text="t('community_preview.label') || 'Community'" light />
      <h2>{{ t('community_preview.heading') || 'Built by the Community, for the Community' }}</h2>
      <div class="stats-grid">
        <div v-for="stat in stats" :key="stat.label" class="stat-card">
          <span class="stat-value">{{ stat.value }}</span>
          <span class="stat-label">{{ stat.label }}</span>
        </div>
      </div>
      <p class="cta">
        <router-link to="/community">{{ t('community_preview.cta') || 'Join the Community →' }}</router-link>
      </p>
    </div>
  </section>
</template>

<style scoped>
.section { padding: clamp(72px, 10vw, 110px) 0; background: var(--color-dark-bg); position: relative; }
.container { max-width: 900px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); text-align: center; position: relative; z-index: 1; }

h2 {
  font-family: var(--font-body); font-size: clamp(1.9rem, 4vw, 2.5rem);
  font-weight: 800; margin-bottom: 3rem; color: #FFFFFF;
}

.stats-grid {
  display: flex; justify-content: center; gap: clamp(24px, 6vw, 64px);
  flex-wrap: wrap;
}
.stat-card {
  text-align: center;
  padding: 28px 32px;
  background: rgba(255,255,255,.03);
  border: 1px solid rgba(255,255,255,.06);
  border-radius: var(--radius-md);
  min-width: 150px;
}
.stat-value {
  display: block;
  font-family: var(--font-display);
  font-size: 2.5rem; font-weight: 600;
  color: var(--color-primary);
  line-height: 1.1;
}
.stat-label {
  display: block;
  font-size: .82rem; color: rgba(255,255,255,.5);
  margin-top: .4rem; font-weight: 600;
}

.cta { margin-top: 2.5rem; }
.cta a {
  color: var(--color-primary); font-weight: 700; font-size: .95rem;
  transition: color .15s;
}
.cta a:hover { color: #FFFFFF; }
</style>
