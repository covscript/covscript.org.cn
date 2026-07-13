<script setup>
import { ref, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
const { t, locale } = useI18n()

const code = ref('')
const output = ref('')
const running = ref(false)
const duration = ref('—')
const todayRuns = ref('—')

const defaultCodeEn = 'system.out.println("Hello, CovScript!")\n\nfunction fib(n)\n    if n <= 1\n        return n\n    else\n        return fib(n - 1) + fib(n - 2)\n    end\nend\n\nforeach i in range(5)\n    system.out.println("fib(" + to_string(i) + ") = " + to_string(fib(i)))\nend'
const defaultCodeZh = 'system.out.println("你好，CovScript！")\n\nfunction fib(n)\n    if n <= 1\n        return n\n    else\n        return fib(n - 1) + fib(n - 2)\n    end\nend\n\nforeach i in range(5)\n    system.out.println("fib(" + to_string(i) + ") = " + to_string(fib(i)))\nend'

function initCode() { code.value = locale.value === 'zh' ? defaultCodeZh : defaultCodeEn }
onMounted(initCode)

const FETCH_TIMEOUT = 20000
const STATS_TIMEOUT = 3000
async function fetchWithTimeout(url, opts = {}, timeout = FETCH_TIMEOUT) {
  const ctrl = new AbortController(); const timer = setTimeout(() => ctrl.abort(), timeout)
  try { return await fetch(url, { ...opts, signal: ctrl.signal }) } finally { clearTimeout(timer) }
}

async function run() {
  if (running.value || !code.value.trim()) return
  running.value = true; output.value = '...'; const start = performance.now()
  try {
    const resp = await fetchWithTimeout('api/run', { method: 'POST', headers: { 'Content-Type': 'text/plain; charset=utf-8' }, body: code.value })
    const dur = Math.round(performance.now() - start); const text = await resp.text()
    try { const data = JSON.parse(text); duration.value = (data.duration_ms != null ? data.duration_ms : dur) + 'ms'; output.value = data.error ? '[Error] ' + data.error : (data.output || '(no output)') } catch { output.value = text }
    fetchStats()
  } catch (e) { output.value = e.name === 'AbortError' ? '[Timeout] Sandbox unavailable.' : '[Error] ' + e.message } finally { running.value = false }
}

async function fetchStats() { try { const r = await fetchWithTimeout('api/stats', {}, STATS_TIMEOUT); if (r.ok) { const d = JSON.parse(await r.text()); todayRuns.value = d.today ?? '—' } } catch { /* */ } }
function reset() { initCode(); output.value = ''; duration.value = '—' }
function onTab(e) { if (e.key === 'Tab') { e.preventDefault(); const ta = e.target; const s = ta.selectionStart; ta.value = ta.value.substring(0, s) + '    ' + ta.value.substring(ta.selectionEnd); ta.selectionStart = ta.selectionEnd = s + 4; code.value = ta.value } }
function onKeydown(e) { if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') { e.preventDefault(); run() } }
onMounted(fetchStats)
</script>

<template>
  <section class="section pg-section" id="playground">
    <div class="bg-dots"></div>
    <div class="container">
      <span class="label">Playground</span>
      <h2 class="title">{{ t('playground.heading') }}</h2>
      <div class="pg-wrapper">
        <div class="pg-panel editor-panel">
          <div class="panel-head"><span>main.ecs</span><span class="panel-kind">SOURCE</span></div>
          <textarea class="pg-editor" v-model="code" spellcheck="false" @keydown.tab="onTab" @keydown="onKeydown"></textarea>
        </div>
        <div class="pg-panel output-panel">
          <div class="panel-head output-head">
            <span>{{ t('playground.output') }}</span>
            <div class="pg-actions">
              <button class="btn-sm reset-btn" @click="reset">{{ t('playground.reset') }}</button>
              <button class="btn-sm run-btn" :disabled="running" @click="run">{{ running ? t('playground.running') : t('playground.run') }}</button>
            </div>
          </div>
          <pre class="pg-output" :class="{ dim: !output }">{{ output || t('playground.loading') }}</pre>
          <div class="pg-stats" aria-live="polite">
            <span>{{ t('playground.duration') }} <strong>{{ duration }}</strong></span>
            <span>{{ t('playground.today_runs') }} <strong>{{ todayRuns }}</strong></span>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.pg-section { background: #e8f3f1; position: relative; overflow: hidden; }
.bg-dots {
  position: absolute; inset: 0; pointer-events: none;
  background-image: radial-gradient(rgba(8,127,116,.1) 1px, transparent 1px);
  background-size: 28px 28px;
}
.section { padding: clamp(72px, 10vw, 120px) 0; }
.container { max-width: 1200px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); position: relative; z-index: 1; }
.label { display: inline-block; font-family: 'DM Mono', monospace; font-size: .72rem; font-weight: 500; color: #087f74; text-transform: uppercase; letter-spacing: .1em; margin-bottom: 1rem; padding: 3px 0; border-bottom: 2px solid #ef7b4a; }
.title { font-family: Manrope, sans-serif; font-size: clamp(1.9rem, 4vw, 2.75rem); font-weight: 800; margin-bottom: 2.5rem; color: #102a43; }
.pg-wrapper { display: grid; grid-template-columns: 1fr 1fr; gap: 1px; background: #294c54; border: 1px solid #294c54; box-shadow: 0 20px 48px rgba(31,66,72,.16); }
.pg-panel { background: #102a43; overflow: hidden; display: flex; flex-direction: column; }
.editor-panel { background: #102a43; }
.output-panel { background: #12343c; }
.panel-head { display: flex; align-items: center; justify-content: space-between; min-height: 46px; padding: 10px 16px; background: rgba(255,255,255,.035); border-bottom: 1px solid rgba(255,255,255,.09); font-family: 'DM Mono', monospace; font-size: .7rem; color: #b9d2d1; }
.panel-kind { color: #65d5c8; font-size: .62rem; letter-spacing: .08em; }
.pg-editor { flex: 1; min-height: 290px; padding: 20px; font-family: 'DM Mono', monospace; font-size: .82rem; line-height: 1.8; color: #effaf8; background: transparent; border: none; outline: none; resize: vertical; tab-size: 4; }
.pg-editor::selection, .pg-output::selection { background: rgba(101,213,200,.3); }
.pg-editor::placeholder { color: #78989d; }
.pg-output { flex: 1; min-height: 290px; padding: 20px; font-family: 'DM Mono', monospace; font-size: .82rem; line-height: 1.8; color: #d6eeea; overflow-y: auto; white-space: pre-wrap; word-break: break-word; margin: 0; }
.pg-output.dim { color: #83a5a5; }
.pg-actions { display: flex; gap: 8px; }
.btn-sm { min-height: 30px; padding: 5px 12px; border-radius: 4px; font-size: .72rem; font-weight: 800; cursor: pointer; border: none; transition: background .2s, transform .2s; }
.run-btn { background: #28bba9; color: #062f37; }
.run-btn:hover:not(:disabled) { background: #65d5c8; transform: translateY(-1px); }
.run-btn:disabled { opacity: .5; cursor: not-allowed; }
.reset-btn { background: transparent; color: #b9d2d1; border: 1px solid rgba(255,255,255,.2); }
.reset-btn:hover { border-color: #65d5c8; color: #fff; background: rgba(101,213,200,.1); }
.pg-stats { display: flex; gap: 22px; padding: 11px 16px; border-top: 1px solid rgba(255,255,255,.09); font-family: 'DM Mono', monospace; font-size: .68rem; color: #8eb4b3; }
.pg-stats strong { color: #65d5c8; font-weight: 500; margin-left: 4px; }
@media (max-width: 768px) {
  .pg-wrapper { grid-template-columns: 1fr; }
  .pg-editor, .pg-output { min-height: 220px; font-size: .76rem; padding: 16px; }
  .panel-head { flex-wrap: wrap; gap: 8px; }
}
@media (max-width: 480px) {
  .pg-editor, .pg-output { min-height: 160px; font-size: .72rem; padding: 14px; }
  .pg-stats { flex-direction: column; gap: 4px; }
  .pg-actions { gap: 6px; }
  .btn-sm { min-height: 28px; padding: 4px 10px; font-size: .68rem; }
}
</style>
