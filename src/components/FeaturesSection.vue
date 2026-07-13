<script setup>
import { useI18n } from 'vue-i18n'
const { t, tm } = useI18n()
</script>

<template>
  <section class="section" id="features">
    <!-- Subtle background accent -->
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
.section { padding: clamp(72px, 10vw, 120px) 0; background: #fff; position: relative; overflow: hidden; }
.bg-accent {
  position: absolute; top: -140px; right: -130px; width: 430px; height: 430px;
  border-radius: 50%; border: 2px solid rgba(18,183,168,.08);
  pointer-events: none;
}
.container { max-width: 1200px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); position: relative; z-index: 1; }
.label {
  display: inline-block; font-family: 'Fira Code', monospace; font-size: .72rem; font-weight: 600;
  color: #087f74; text-transform: uppercase; letter-spacing: .1em; margin-bottom: 1rem;
  padding: 3px 0; border-bottom: 2px solid #ef7b4a;
}
.title { font-family: Manrope, sans-serif; font-size: clamp(1.9rem, 4vw, 2.75rem); font-weight: 800; margin-bottom: 3rem; color: #102a43; }
.grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1px; background: #d9e6e3; border: 1px solid #d9e6e3; }
.card {
  background: #fff; padding: 32px 28px; transition: background .25s ease, transform .25s ease; position: relative; overflow: hidden;
  opacity: 0; transform: translateY(24px); animation: fadeUp .5s ease forwards;
}
@keyframes fadeUp { to { opacity: 1; transform: translateY(0); } }
.card::before {
  content: ''; position: absolute; top: 0; left: 0; width: 4px; height: 100%;
  background: #12b7a8; opacity: 0; transition: opacity .25s ease;
}
.card:hover { background: #f5fbfa; transform: translateY(-3px); }
.card:hover::before { opacity: 1; }
.card-icon { font-size: 2rem; margin-bottom: .75rem; display: block; filter: grayscale(0); }
.card h3 { font-family: Manrope, sans-serif; font-size: 1.1rem; font-weight: 800; color: #102a43; margin-bottom: .5rem; }
.card p { color: #526f7a; font-size: .88rem; line-height: 1.7; }
@media (max-width: 768px) { .grid { grid-template-columns: 1fr; } }
@media (min-width: 769px) and (max-width: 1024px) { .grid { grid-template-columns: repeat(2, 1fr); } }
</style>
