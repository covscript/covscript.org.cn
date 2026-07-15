<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import { useI18n } from 'vue-i18n'
const { t } = useI18n()
const canvas = ref(null)
let animId

onMounted(() => {
  const c = canvas.value; if (!c) return
  const ctx = c.getContext('2d')
  let w, h
  const particles = []
  function resize() { w = c.width = c.offsetWidth * devicePixelRatio; h = c.height = c.offsetHeight * devicePixelRatio; ctx.setTransform(devicePixelRatio, 0, 0, devicePixelRatio, 0, 0) }
  resize(); window.addEventListener('resize', resize)
  for (let i = 0; i < 60; i++) particles.push({ x: Math.random() * w, y: Math.random() * h, vx: (Math.random() - .5) * .4, vy: (Math.random() - .5) * .4, r: Math.random() * 2 + .4, a: Math.random() * .3 + .06, as: (Math.random() - .5) * .003 })
  function draw() {
    ctx.clearRect(0, 0, w / devicePixelRatio, h / devicePixelRatio)
    const rw = w / devicePixelRatio, rh = h / devicePixelRatio
    particles.forEach(p => {
      p.x += p.vx; p.y += p.vy; p.a += p.as
      if (p.a <= .03 || p.a >= .4) p.as *= -1
      if (p.x < -10) p.x = rw + 10; if (p.x > rw + 10) p.x = -10
      if (p.y < -10) p.y = rh + 10; if (p.y > rh + 10) p.y = -10
      ctx.beginPath(); ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2)
      ctx.fillStyle = `rgba(0,196,180,${p.a})`; ctx.fill()
    })
    for (let i = 0; i < particles.length; i++) {
      for (let j = i + 1; j < particles.length; j++) {
        const dx = particles[i].x - particles[j].x, dy = particles[i].y - particles[j].y, d = Math.sqrt(dx * dx + dy * dy)
        if (d < 110) { ctx.beginPath(); ctx.moveTo(particles[i].x, particles[i].y); ctx.lineTo(particles[j].x, particles[j].y); ctx.strokeStyle = `rgba(0,196,180,${.05 * (1 - d / 110)})`; ctx.lineWidth = .5; ctx.stroke() }
      }
    }
    animId = requestAnimationFrame(draw)
  }
  draw()
})
onUnmounted(() => cancelAnimationFrame(animId))
</script>

<template>
  <section class="hero">
    <canvas ref="canvas" class="particles"></canvas>
    <!-- Gradient overlay -->
    <div class="hero-gradient"></div>
    <!-- Geometric decorations -->
    <div class="geo geo-1"></div>
    <div class="geo geo-2"></div>
    <div class="geo geo-3"></div>
    <div class="hero-content">
      <span class="version-badge">{{ t('hero.version') || 'v2.x' }}</span>
      <h1>{{ t('hero.title') }}</h1>
      <p class="hero-subtitle">{{ t('hero.subtitle') }}</p>
      <p class="hero-desc">{{ t('hero.desc') }}</p>
      <div class="hero-cta">
        <a href="#/playground" class="btn btn-primary">{{ t('hero.cta_playground') }}</a>
        <a href="https://github.com/covscript" target="_blank" rel="noopener" class="btn btn-outline">{{ t('hero.cta_github') }}</a>
      </div>
    </div>
  </section>
</template>

<style scoped>
.hero {
  min-height: min(820px, 100vh); display: flex; align-items: center; justify-content: center;
  position: relative; overflow: hidden;
  background: var(--color-dark-bg);
}
.hero-gradient {
  position: absolute; inset: 0; pointer-events: none; z-index: 0;
  background: radial-gradient(ellipse 80% 60% at 50% -10%, rgba(0,196,180,0.12) 0%, transparent 60%),
              radial-gradient(ellipse 50% 50% at 80% 80%, rgba(255,92,53,0.06) 0%, transparent 60%);
}
.particles { position: absolute; inset: 0; pointer-events: none; z-index: 0; }
.geo { position: absolute; border-radius: 50%; pointer-events: none; z-index: 0; }
.geo-1 {
  width: 600px; height: 600px; top: -150px; right: -200px;
  border: 2px solid rgba(0,196,180,.1);
  background: radial-gradient(circle, rgba(0,196,180,.06) 0%, transparent 70%);
}
.geo-2 {
  width: 400px; height: 400px; bottom: -100px; left: -100px;
  border: 1.5px solid rgba(255,92,53,.1);
  background: radial-gradient(circle, rgba(255,92,53,.05) 0%, transparent 65%);
}
.geo-3 {
  width: 200px; height: 200px; top: 30%; left: 10%;
  border: 1px solid rgba(0,196,180,.14);
}
.hero-content { position: relative; z-index: 1; text-align: center; max-width: 820px; padding: 0 24px; }

.version-badge {
  display: inline-block;
  font-family: var(--font-code);
  font-size: 0.72rem;
  font-weight: 500;
  color: var(--color-primary);
  background: rgba(0,196,180,0.08);
  border: 1px solid rgba(0,196,180,0.2);
  padding: 3px 10px;
  border-radius: var(--radius-sm);
  margin-bottom: 1.5rem;
  letter-spacing: 0.05em;
}

.hero-content h1 {
  font-family: var(--font-display);
  font-size: clamp(3rem, 8vw, 5.5rem); font-weight: 600;
  line-height: 1.02; margin-bottom: 1rem; letter-spacing: -0.01em;
  color: #FFFFFF;
  background: linear-gradient(135deg, #FFFFFF 0%, var(--color-primary) 70%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.hero-content h1::after {
  content: ''; display: block; width: 80px; height: 4px;
  background: var(--color-accent); border-radius: 0;
  margin: 1.25rem auto 0;
}
.hero-subtitle {
  font-family: var(--font-body); font-size: clamp(1.05rem, 2.5vw, 1.35rem);
  font-weight: 700; color: var(--color-primary); margin-bottom: .75rem;
  opacity: 0.9;
}
.hero-desc {
  font-size: .95rem; color: rgba(255,255,255,0.6);
  max-width: 560px; margin: 0 auto 2.5rem; line-height: 1.75;
}
.hero-cta { display: flex; gap: 14px; justify-content: center; flex-wrap: wrap; }

.btn {
  display: inline-flex; align-items: center; justify-content: center;
  min-height: 48px; padding: 12px 28px; border-radius: var(--radius-md);
  font-weight: 800; font-size: .87rem; cursor: pointer;
  transition: transform .2s, box-shadow .2s, background .2s;
  border: none; text-decoration: none;
}
.btn-primary {
  background: var(--color-primary); color: var(--color-dark-bg);
  box-shadow: 0 8px 24px rgba(0,196,180,.3);
}
.btn-primary:hover {
  background: var(--color-primary-hover);
  box-shadow: 0 12px 32px rgba(0,196,180,.4);
  transform: translateY(-2px);
}
.btn-outline {
  background: transparent; color: #FFFFFF;
  border: 1.5px solid rgba(255,255,255,.25);
}
.btn-outline:hover { border-color: var(--color-primary); color: var(--color-primary); background: rgba(0,196,180,.06); }
@media (max-width: 768px) { .hero { min-height: 700px; } .geo { display: none; } }
</style>
