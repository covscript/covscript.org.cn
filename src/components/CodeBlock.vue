<script setup>
import { ref } from 'vue'

const props = defineProps({
  code: { type: String, required: true },
  language: { type: String, default: 'CovScript' },
})

const copied = ref(false)

async function copy() {
  try {
    await navigator.clipboard.writeText(props.code)
    copied.value = true
    setTimeout(() => { copied.value = false }, 2000)
  } catch { /* clipboard unavailable */ }
}
</script>

<template>
  <div class="code-block">
    <div class="code-bar">
      <span class="code-lang">{{ language }}</span>
      <button class="copy-btn" @click="copy">{{ copied ? 'Copied!' : 'Copy' }}</button>
    </div>
    <pre><code>{{ code }}</code></pre>
  </div>
</template>

<style scoped>
.code-block {
  background: var(--color-code-bg);
  border: 1px solid rgba(255,255,255,.06);
  border-radius: var(--radius-md);
  overflow: hidden;
}
.code-bar {
  display: flex; align-items: center; justify-content: space-between;
  padding: 8px 14px;
  background: rgba(255,255,255,.02);
  border-bottom: 1px solid rgba(255,255,255,.06);
}
.code-lang {
  font-family: var(--font-code);
  font-size: .65rem; color: var(--color-primary);
  text-transform: uppercase; letter-spacing: .06em;
}
.copy-btn {
  background: transparent; border: 1px solid rgba(255,255,255,.12);
  color: rgba(255,255,255,.5); font-size: .68rem; font-weight: 600;
  padding: 2px 10px; border-radius: var(--radius-sm); cursor: pointer;
  transition: all .15s;
}
.copy-btn:hover { border-color: var(--color-primary); color: var(--color-primary); }
pre {
  padding: 16px 20px; margin: 0; overflow-x: auto;
  font-family: var(--font-code); font-size: .82rem; line-height: 1.75;
  color: var(--color-code-text);
}
pre code { background: none; }
</style>
