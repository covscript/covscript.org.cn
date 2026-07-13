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
      ctx.fillStyle = `rgba(124,58,237,${p.a})`; ctx.fill()
    })
    for (let i = 0; i < particles.length; i++) {
      for (let j = i + 1; j < particles.length; j++) {
        const dx = particles[i].x - particles[j].x, dy = particles[i].y - particles[j].y, d = Math.sqrt(dx * dx + dy * dy)
        if (d < 110) { ctx.beginPath(); ctx.moveTo(particles[i].x, particles[i].y); ctx.lineTo(particles[j].x, particles[j].y); ctx.strokeStyle = `rgba(124,58,237,${.04 * (1 - d / 110)})`; ctx.lineWidth = .5; ctx.stroke() }
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
    <!-- Geometric decorations inspired by logo C-shape -->
    <div class="geo geo-1"></div>
    <div class="geo geo-2"></div>
    <div class="geo geo-3"></div>
    <div class="hero-content">
      <h1>{{ t('hero.title') }}</h1>
      <p class="hero-subtitle">{{ t('hero.subtitle') }}</p>
      <p class="hero-desc">{{ t('hero.desc') }}</p>
      <div class="hero-cta">
        <a href="#playground" class="btn btn-primary">{{ t('hero.cta_playground') }}</a>
        <a href="https://github.com/covscript" target="_blank" rel="noopener" class="btn btn-outline">{{ t('hero.cta_github') }}</a>
      </div>
    </div>
  </section>
</template>

<style scoped>
.hero {
  min-height: min(780px, 100vh); display: flex; align-items: center; justify-content: center;
  position: relative; overflow: hidden;
  background: linear-gradient(145deg, #f7faf9 0%, #e5f3ef 47%, #dceceb 100%);
}
.particles { position: absolute; inset: 0; pointer-events: none; z-index: 0; }
.geo { position: absolute; border-radius: 50%; pointer-events: none; z-index: 0; }
.geo-1 {
  width: 600px; height: 600px; top: -150px; right: -200px;
  border: 2px solid rgba(18,183,168,.12);
  background: radial-gradient(circle, rgba(18,183,168,.08) 0%, transparent 70%);
}
.geo-2 {
  width: 400px; height: 400px; bottom: -100px; left: -100px;
  border: 1.5px solid rgba(239,123,74,.13);
  background: radial-gradient(circle, rgba(239,123,74,.08) 0%, transparent 65%);
}
.geo-3 {
  width: 200px; height: 200px; top: 30%; left: 10%;
  border: 1px solid rgba(18,183,168,.18);
}
.hero-content { position: relative; z-index: 1; text-align: center; max-width: 800px; padding: 0 24px; }
.hero-content h1 {
  font-family: 'Eras Demi ITC', 'Manrope', sans-serif; font-size: clamp(2.8rem, 7vw, 5rem); font-weight: 600;
  line-height: 1.05; margin-bottom: 1.25rem; letter-spacing: 0; color: #102a43;
}
.hero-content h1::after {
  content: ''; display: block; width: 80px; height: 4px;
  background: #ef7b4a; border-radius: 0;
  margin: 1.25rem auto 0;
}
.hero-subtitle { font-family: Manrope, sans-serif; font-size: clamp(1.05rem, 2.5vw, 1.3rem); font-weight: 700; color: #24545c; margin-bottom: .75rem; }
.hero-desc { font-size: .95rem; color: #486581; max-width: 540px; margin: 0 auto 2.5rem; line-height: 1.75; }
.hero-cta { display: flex; gap: 14px; justify-content: center; flex-wrap: wrap; }
.btn { display: inline-flex; align-items: center; justify-content: center; min-height: 48px; padding: 12px 26px; border-radius: 5px; font-weight: 800; font-size: .87rem; cursor: pointer; transition: transform .2s, box-shadow .2s, background .2s; border: none; text-decoration: none; }
.btn-primary { background: #0e8077; color: #fff; box-shadow: 0 10px 20px rgba(14,128,119,.2); }
.btn-primary:hover { background: #07685f; box-shadow: 0 14px 24px rgba(14,128,119,.24); transform: translateY(-2px); }
.btn-outline { background: rgba(255,255,255,.62); color: #102a43; border: 1px solid #9bb8b2; }
.btn-outline:hover { border-color: #0e8077; color: #07685f; background: #fff; }
@media (max-width: 768px) { .hero { min-height: 680px; } .geo { display: none; } }
</style>
