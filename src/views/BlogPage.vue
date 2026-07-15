<script setup>
import { useI18n } from 'vue-i18n'
import PageHero from '../components/PageHero.vue'

const { t } = useI18n()

// Static blog data — expand or replace with API fetch
const posts = [
  // { date: '2026-07-01', title: '...', excerpt: '...', url: '...' },
]
</script>

<template>
  <PageHero :heading="t('blog_page.hero_title')" :subtitle="t('blog_page.hero_sub')" />

  <section class="section">
    <div class="container">
      <template v-if="posts.length">
        <article v-for="(post, i) in posts" :key="i" class="post-card">
          <time class="post-date">{{ post.date }}</time>
          <h2 class="post-title">{{ post.title }}</h2>
          <p class="post-excerpt">{{ post.excerpt }}</p>
          <a v-if="post.url" :href="post.url" class="post-link" target="_blank" rel="noopener">{{ t('blog_page.read_more') }}</a>
        </article>
      </template>
      <div v-else class="empty">
        <p>{{ t('blog_page.no_posts') }}</p>
      </div>
    </div>
  </section>
</template>

<style scoped>
.section { padding: clamp(48px, 8vw, 80px) 0; background: var(--color-bg); min-height: 50vh; }
.container { max-width: 800px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 80px); }

.post-card { padding: 28px 0; border-bottom: 1px solid var(--color-border); }
.post-card:first-child { padding-top: 0; }
.post-date { font-family: var(--font-code); font-size: .75rem; color: var(--color-text-muted); }
.post-title { font-size: 1.3rem; font-weight: 800; color: var(--color-text); margin: .35rem 0 .5rem; }
.post-excerpt { color: var(--color-text-secondary); font-size: .9rem; line-height: 1.7; }
.post-link { display: inline-block; margin-top: .5rem; color: var(--color-primary-deep); font-weight: 700; font-size: .85rem; }
.post-link:hover { color: var(--color-primary); }

.empty { text-align: center; padding: 64px 0; }
.empty p { color: var(--color-text-muted); font-size: 1.1rem; }
</style>
