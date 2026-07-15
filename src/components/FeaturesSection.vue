<script setup>
import { useI18n } from 'vue-i18n'
const { t, tm } = useI18n()
</script>

<template>
  <section class="section" id="features">
    <div class="bg-accent"></div>
    <div class="container">
      <span class="label">Why CovScript</span>
      <h2 class="title">{{ t('features.heading') }}</h2>
      <div class="grid">
        <div v-for="(item, i) in tm('features.items')" :key="i" class="card" :style="{ animationDelay: i * 80 + 'ms' }">
          <span class="card-icon">{{ item.icon }}</span>
          <h3>{{ item.title }}</h3>
          <p>{{ item.desc }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.section { padding: clamp(80px, 10vw, 120px) 0; background: var(--color-bg); position: relative; overflow: hidden; }
.bg-accent {
  position: absolute; top: -140px; right: -130px; width: 430px; height: 430px;
  border-radius: 50%; border: 2px solid rgba(0,196,180,.08);
  pointer-events: none;
}
.container { max-width: 1200px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); position: relative; z-index: 1; }
.label {
  display: inline-block; font-family: var(--font-code); font-size: .72rem; font-weight: 500;
  color: var(--color-primary-deep); text-transform: uppercase; letter-spacing: .1em; margin-bottom: 1rem;
  padding: 3px 0; border-bottom: 3px solid var(--color-accent);
}
.title { font-family: var(--font-body); font-size: clamp(1.9rem, 4vw, 2.75rem); font-weight: 800; margin-bottom: 3rem; color: var(--color-text); }
.grid {
  display: grid; grid-template-columns: repeat(3, 1fr);
  gap: 1px; background: var(--color-border);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  overflow: hidden;
}
.card {
  background: var(--color-surface); padding: 36px 28px;
  transition: background .25s ease, transform .25s ease, box-shadow .25s ease;
  position: relative; overflow: hidden;
  opacity: 0; transform: translateY(24px); animation: fadeUp .5s ease forwards;
}
@keyframes fadeUp { to { opacity: 1; transform: translateY(0); } }
.card::after {
  content: ''; position: absolute; inset: 0; pointer-events: none;
  background: radial-gradient(circle at 50% 0%, rgba(0,196,180,0.06) 0%, transparent 60%);
  opacity: 0; transition: opacity .25s ease;
}
.card:hover {
  background: #F8FDFC;
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
}
.card:hover::after { opacity: 1; }
.card-icon { font-size: 2rem; margin-bottom: .75rem; display: block; filter: grayscale(0); }
.card h3 { font-family: var(--font-body); font-size: 1.1rem; font-weight: 800; color: var(--color-text); margin-bottom: .5rem; }
.card p { color: var(--color-text-secondary); font-size: .88rem; line-height: 1.7; }
@media (max-width: 768px) { .grid { grid-template-columns: 1fr; } }
@media (min-width: 769px) and (max-width: 1024px) { .grid { grid-template-columns: repeat(2, 1fr); } }
</style>
