<script setup>
defineProps({
  os: { type: String, required: true },
  name: { type: String, required: true },
  description: { type: String, required: true },
  url: { type: String, required: true },
})
</script>

<template>
  <a :href="url" class="dl-card" target="_blank" rel="noopener">
    <span class="dl-icon">
      <i v-if="os === 'windows'" class="fa-brands fa-windows"></i>
      <i v-else-if="os === 'macos'" class="fa-brands fa-apple"></i>
      <i v-else-if="os === 'ubuntu' || os === 'ubuntu_arm'" class="fa-brands fa-ubuntu"></i>
      <i v-else class="fa-solid fa-download"></i>
    </span>
    <div>
      <span class="dl-name">{{ name }}</span>
      <span class="dl-desc">{{ description }}</span>
    </div>
  </a>
</template>

<style scoped>
.dl-card {
  background: var(--color-surface); padding: 28px 24px; display: flex;
  align-items: center; gap: 18px; text-decoration: none; color: inherit;
  transition: background .2s, transform .2s; border-radius: var(--radius-sm);
}
.dl-card:hover { background: #F8FDFC; transform: translateY(-2px); }
.dl-icon { font-size: 1.75rem; width: 40px; text-align: center; flex-shrink: 0; color: var(--color-text-secondary); }
.dl-name { display: block; font-weight: 800; font-size: .95rem; color: var(--color-text); margin-bottom: 2px; }
.dl-desc { display: block; font-size: .8rem; color: var(--color-text-muted); }
</style>
