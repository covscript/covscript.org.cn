<script setup>
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import PageHero from '../components/PageHero.vue'
import CodeBlock from '../components/CodeBlock.vue'

const { t } = useI18n()

const docCards = [
  { icon: '🚀', titleKey: 'docs_page.getting_started', descKey: 'docs_page.getting_started_desc', href: 'https://github.com/covscript/covscript' },
  { icon: '📖', titleKey: 'docs_page.lang_guide', descKey: 'docs_page.lang_guide_desc', href: 'https://github.com/covscript/covscript' },
  { icon: '📚', titleKey: 'docs_page.stdlib', descKey: 'docs_page.stdlib_desc', href: 'https://github.com/covscript/covscript' },
  { icon: '🔍', titleKey: 'docs_page.api_ref', descKey: 'docs_page.api_ref_desc', href: 'https://github.com/covscript/covscript' },
  { icon: '📦', titleKey: 'docs_page.pkg_mgr', descKey: 'docs_page.pkg_mgr_desc', href: 'https://github.com/covscript/covscript' },
  { icon: '🐛', titleKey: 'docs_page.debugger', descKey: 'docs_page.debugger_desc', href: 'https://github.com/covscript/covscript' },
]

const tourExamples = [
  {
    titleKey: 'docs_page.tour_vars',
    code: 'auto name = "CovScript"\nauto version = 2.0\nauto is_cool = true\n\nsystem.out.println("Hello, " + name)\nsystem.out.println("Version: " + to_string(version))',
  },
  {
    titleKey: 'docs_page.tour_funcs',
    code: 'function greet(name)\n    system.out.println("Hello, " + name + "!")\nend\n\nfunction add(a, b)\n    return a + b\nend\n\ngreet("World")\nsystem.out.println(to_string(add(3, 4)))',
  },
  {
    titleKey: 'docs_page.tour_ctrl',
    code: 'foreach i in range(5)\n    if i % 2 == 0\n        system.out.println(to_string(i) + " is even")\n    else\n        system.out.println(to_string(i) + " is odd")\n    end\nend\n\nwhile true\n    system.out.println("loop")\n    break\nend',
  },
]

const expandedIndex = ref(null)
</script>

<template>
  <PageHero :heading="t('docs_page.hero_title')" :subtitle="t('docs_page.hero_sub')" />

  <!-- Document Cards -->
  <section class="section">
    <div class="container">
      <div class="card-grid">
        <a
          v-for="card in docCards"
          :key="card.titleKey"
          :href="card.href"
          class="doc-card"
          target="_blank"
          rel="noopener"
        >
          <span class="card-icon">{{ card.icon }}</span>
          <h3>{{ t(card.titleKey) }}</h3>
          <p>{{ t(card.descKey) }}</p>
        </a>
      </div>
    </div>
  </section>

  <!-- Quick Tour -->
  <section class="section tour-section">
    <div class="container">
      <h2 class="tour-title">{{ t('docs_page.quick_tour') }}</h2>
      <div class="tour-list">
        <div v-for="(ex, i) in tourExamples" :key="i" class="tour-item">
          <button class="tour-header" @click="expandedIndex = expandedIndex === i ? null : i">
            <span>{{ t(ex.titleKey) }}</span>
            <span class="toggle">{{ expandedIndex === i ? '−' : '+' }}</span>
          </button>
          <div v-if="expandedIndex === i" class="tour-code">
            <CodeBlock :code="ex.code" />
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Resources -->
  <section class="section">
    <div class="container">
      <h2 class="section-title">{{ t('docs_page.resources') }}</h2>
      <p class="section-desc">{{ t('docs_page.resources_desc') }}</p>
      <p class="cta-link">
        <a href="https://github.com/covscript/covscript" target="_blank" rel="noopener">{{ t('docs_page.visit_docs') }}</a>
      </p>
    </div>
  </section>
</template>

<style scoped>
.section { padding: clamp(48px, 8vw, 80px) 0; background: var(--color-bg); }
.tour-section { background: var(--color-surface); }
.container { max-width: 1000px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); }

/* Card Grid */
.card-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1px; background: var(--color-border); border: 1px solid var(--color-border); border-radius: var(--radius-sm); overflow: hidden; }
.doc-card {
  background: var(--color-surface); padding: 28px 22px; text-decoration: none; color: inherit;
  transition: background .2s, transform .2s;
}
.doc-card:hover { background: #F8FDFC; transform: translateY(-2px); }
.card-icon { font-size: 1.75rem; display: block; margin-bottom: .6rem; }
.doc-card h3 { font-size: 1rem; font-weight: 800; color: var(--color-text); margin-bottom: .35rem; }
.doc-card p { font-size: .82rem; color: var(--color-text-secondary); line-height: 1.6; }

/* Tour */
.tour-title { font-size: 1.75rem; font-weight: 800; color: var(--color-text); margin-bottom: 2rem; }
.tour-list { display: flex; flex-direction: column; gap: 1px; background: var(--color-border); border: 1px solid var(--color-border); border-radius: var(--radius-sm); overflow: hidden; }
.tour-item { background: var(--color-bg); }
.tour-header {
  width: 100%; display: flex; align-items: center; justify-content: space-between;
  padding: 16px 20px; background: none; border: none;
  font-size: .92rem; font-weight: 700; color: var(--color-text);
  cursor: pointer; font-family: var(--font-body); text-align: left;
}
.tour-header:hover { background: rgba(0,196,180,.03); }
.toggle { font-family: var(--font-code); font-size: 1.1rem; color: var(--color-primary); }
.tour-code { padding: 0 16px 16px; }

.section-title { font-size: 1.75rem; font-weight: 800; color: var(--color-text); margin-bottom: .5rem; }
.section-desc { color: var(--color-text-secondary); font-size: .9rem; }
.cta-link { margin-top: 1.25rem; }
.cta-link a { color: var(--color-primary-deep); font-weight: 700; font-size: .92rem; }
.cta-link a:hover { color: var(--color-primary); }

@media (max-width: 768px) { .card-grid { grid-template-columns: 1fr; } }
</style>
