<script setup>
import { ref, computed } from 'vue'
import { useI18n } from 'vue-i18n'
import CodeBlock from './CodeBlock.vue'
import SectionLabel from './SectionLabel.vue'

const { t } = useI18n()

const examples = {
  hello: {
    label: 'Hello World',
    code: `system.out.println("Hello, CovScript!")\n\n// Variables and types\nauto num = 42\nauto text = "Covariant Script"\nauto flag = true\n\nsystem.out.println("Number: " + to_string(num))\nsystem.out.println("Text: " + text)`,
  },
  fib: {
    label: 'Fibonacci',
    code: `function fib(n)\n    if n <= 1\n        return n\n    else\n        return fib(n - 1) + fib(n - 2)\n    end\nend\n\nforeach i in range(10)\n    system.out.println(\n        "fib(" + to_string(i) + ") = "\n        + to_string(fib(i)))\nend`,
  },
  async: {
    label: 'Async / Await',
    code: `function async_task(id, delay)\n    system.out.println(\n        "Task " + to_string(id)\n        + " started")\n\n    // Simulate async work\n    await timer(delay)\n\n    system.out.println(\n        "Task " + to_string(id)\n        + " done")\n\n    return "result-" + to_string(id)\nend\n\n// Launch concurrent tasks\nauto results = await all([\n    async_task(1, 500),\n    async_task(2, 300),\n    async_task(3, 700)\n])\n\nsystem.out.println(\n    "All done: " + to_string(results))`,
  },
}

const activeTab = ref('hello')
const currentExample = computed(() => examples[activeTab.value])

function copyCurrent() {
  navigator.clipboard.writeText(currentExample.value.code).catch(() => {})
}
</script>

<template>
  <section class="showcase">
    <div class="container">
      <SectionLabel text="Code Examples" light />
      <h2>{{ t('showcase.heading') || 'See CovScript in Action' }}</h2>
      <div class="showcase-card">
        <div class="tabs">
          <button
            v-for="(ex, key) in examples"
            :key="key"
            class="tab"
            :class="{ active: activeTab === key }"
            @click="activeTab = key"
          >{{ ex.label }}</button>
          <button class="copy-btn" @click="copyCurrent">Copy</button>
        </div>
        <div class="code-body">
          <pre><code>{{ currentExample.code }}</code></pre>
        </div>
      </div>
      <p class="showcase-cta">
        <router-link to="/playground">{{ t('showcase.try_it') || 'Try it in Playground →' }}</router-link>
      </p>
    </div>
  </section>
</template>

<style scoped>
.showcase {
  padding: clamp(80px, 10vw, 120px) 0;
  background: var(--color-dark-surface);
  position: relative;
}
.container { max-width: 900px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); position: relative; z-index: 1; }

h2 {
  font-family: var(--font-body); font-size: clamp(1.9rem, 4vw, 2.75rem);
  font-weight: 800; margin-bottom: 2.5rem; color: #FFFFFF;
}

.showcase-card {
  background: var(--color-code-bg);
  border: 1px solid rgba(255,255,255,.06);
  border-radius: var(--radius-md);
  overflow: hidden;
  box-shadow: 0 20px 48px rgba(0,0,0,.3);
}

.tabs {
  display: flex; align-items: center;
  padding: 8px 14px; gap: 4px;
  background: rgba(255,255,255,.02);
  border-bottom: 1px solid rgba(255,255,255,.06);
}
.tab {
  background: transparent; border: none;
  color: rgba(255,255,255,.45); font-size: .75rem; font-weight: 700;
  padding: 6px 14px; border-radius: var(--radius-sm); cursor: pointer;
  transition: all .15s; font-family: var(--font-body);
}
.tab:hover { color: rgba(255,255,255,.7); }
.tab.active { background: rgba(0,196,180,.12); color: var(--color-primary); }
.copy-btn {
  margin-left: auto; background: transparent;
  border: 1px solid rgba(255,255,255,.12);
  color: rgba(255,255,255,.5); font-size: .68rem; font-weight: 600;
  padding: 4px 12px; border-radius: var(--radius-sm); cursor: pointer;
  transition: all .15s;
}
.copy-btn:hover { border-color: var(--color-primary); color: var(--color-primary); }

.code-body pre {
  padding: 24px 28px; margin: 0; overflow-x: auto;
  font-family: var(--font-code); font-size: .85rem; line-height: 1.8;
  color: var(--color-code-text);
  min-height: 260px;
}

.showcase-cta { text-align: center; margin-top: 2rem; }
.showcase-cta a {
  color: var(--color-primary); font-weight: 700; font-size: .95rem;
  transition: color .15s;
}
.showcase-cta a:hover { color: #FFFFFF; }

@media (max-width: 600px) {
  .tabs { flex-wrap: wrap; gap: 2px; }
  .code-body pre { padding: 16px; font-size: .76rem; }
}
</style>
