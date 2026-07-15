<script setup>
defineProps({
  heading: { type: String, required: true },
  subtitle: { type: String, default: '' },
})
</script>

<template>
  <section class="page-hero">
    <div class="bg-gradient"></div>
    <div class="container">
      <h1>{{ heading }}</h1>
      <p v-if="subtitle" class="subtitle">{{ subtitle }}</p>
    </div>
  </section>
</template>

<style scoped>
.page-hero {
  padding: clamp(100px, 14vw, 160px) 0 clamp(48px, 6vw, 72px);
  background: var(--color-dark-bg);
  position: relative; overflow: hidden;
}
.bg-gradient {
  position: absolute; inset: 0; pointer-events: none;
  background: radial-gradient(ellipse 60% 50% at 50% 0%, rgba(0,196,180,.08) 0%, transparent 60%);
}
.container { max-width: 900px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); position: relative; z-index: 1; text-align: center; }
h1 {
  font-family: var(--font-display);
  font-size: clamp(2.2rem, 6vw, 3.75rem); font-weight: 600;
  line-height: 1.1; color: #FFFFFF;
  background: linear-gradient(135deg, #FFFFFF 0%, var(--color-primary) 80%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
h1::after {
  content: ''; display: block; width: 64px; height: 4px;
  background: var(--color-accent); margin: 1rem auto 0;
}
.subtitle {
  margin-top: 1rem; font-size: 1.05rem; color: rgba(255,255,255,.55);
  max-width: 560px; margin-left: auto; margin-right: auto;
}
</style>
