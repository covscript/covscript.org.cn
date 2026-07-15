<script setup>
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import PlaygroundSection from '../components/PlaygroundSection.vue'

const { t } = useI18n()

const examples = [
  {
    label: 'Hello World',
    code: 'system.out.println("Hello, CovScript!")\n\n// Try changing the message!\nauto msg = "Welcome to CovScript"\nsystem.out.println(msg)',
  },
  {
    label: 'Fibonacci',
    code: 'function fib(n)\n    if n <= 1\n        return n\n    else\n        return fib(n - 1) + fib(n - 2)\n    end\nend\n\nforeach i in range(5)\n    system.out.println("fib(" + to_string(i) + ") = " + to_string(fib(i)))\nend',
  },
  {
    label: 'Arrays & Loops',
    code: 'auto numbers = [1, 2, 3, 4, 5]\nauto sum = 0\n\nforeach n in numbers\n    sum += n\n    system.out.println("Adding " + to_string(n) + ": sum = " + to_string(sum))\nend\n\nsystem.out.println("Total: " + to_string(sum))',
  },
  {
    label: 'String Ops',
    code: 'auto text = "Covariant Script"\n\nsystem.out.println("Length: " + to_string(text.length()))\nsystem.out.println("Upper: " + text.upper())\nsystem.out.println("Lower: " + text.lower())\nsystem.out.println("Substr: " + text.substr(0, 8))',
  },
]
</script>

<template>
  <section class="pg-page">
    <div class="pg-layout">
      <aside class="pg-sidebar">
        <h3>Examples</h3>
        <ul>
          <li v-for="ex in examples" :key="ex.label">
            <button class="example-btn" @click="/* populated by PlaygroundSection */">{{ ex.label }}</button>
          </li>
        </ul>
        <div class="sidebar-footer">
          <p class="sidebar-hint">Click an example to load it into the editor.</p>
          <router-link to="/" class="back-link">← {{ t('page.back_home') }}</router-link>
        </div>
      </aside>
      <main class="pg-main">
        <PlaygroundSection />
      </main>
    </div>
  </section>
</template>

<style scoped>
.pg-page { min-height: 100vh; background: var(--color-dark-bg); padding-top: 72px; }
.pg-layout { display: flex; min-height: calc(100vh - 72px); }
.pg-sidebar {
  width: 240px; flex-shrink: 0;
  background: rgba(255,255,255,.02);
  border-right: 1px solid rgba(255,255,255,.05);
  padding: 24px 16px;
  display: flex; flex-direction: column;
}
.pg-sidebar h3 {
  font-family: var(--font-body); font-size: .8rem; font-weight: 800;
  color: var(--color-primary); text-transform: uppercase;
  letter-spacing: .06em; margin-bottom: 1rem;
}
.pg-sidebar ul { list-style: none; flex: 1; }
.example-btn {
  width: 100%; text-align: left; padding: 8px 12px;
  background: none; border: 1px solid transparent;
  border-radius: var(--radius-sm);
  color: rgba(255,255,255,.6); font-size: .78rem; font-weight: 600;
  cursor: pointer; transition: all .15s; margin-bottom: 2px;
  font-family: var(--font-code);
}
.example-btn:hover { background: rgba(0,196,180,.06); color: var(--color-primary); border-color: rgba(0,196,180,.15); }
.sidebar-footer { margin-top: auto; padding-top: 16px; border-top: 1px solid rgba(255,255,255,.06); }
.sidebar-hint { font-size: .68rem; color: rgba(255,255,255,.25); margin-bottom: .75rem; }
.back-link { font-size: .75rem; color: rgba(255,255,255,.4); font-weight: 600; }
.back-link:hover { color: var(--color-primary); }
.pg-main { flex: 1; overflow: auto; }

@media (max-width: 768px) {
  .pg-layout { flex-direction: column; }
  .pg-sidebar { width: 100%; border-right: none; border-bottom: 1px solid rgba(255,255,255,.05); flex-direction: row; flex-wrap: wrap; align-items: center; gap: 8px; padding: 14px; }
  .pg-sidebar h3 { margin-bottom: 0; margin-right: 8px; }
  .pg-sidebar ul { display: flex; gap: 4px; flex-wrap: wrap; }
  .example-btn { width: auto; font-size: .7rem; padding: 5px 10px; }
  .sidebar-footer { display: none; }
}
</style>
