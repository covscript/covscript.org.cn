<script setup>
defineProps({
  text: { type: String, required: true },
  light: { type: Boolean, default: false },
})
</script>

<template>
  <span class="label" :class="{ light }">{{ text }}</span>
</template>

<style scoped>
.label {
  display: inline-block;
  font-family: var(--font-code);
  font-size: .72rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: .1em;
  margin-bottom: 1rem;
  padding: 3px 0;
  border-bottom: 3px solid var(--color-accent);
  color: var(--color-primary-deep);
}
.label.light {
  color: var(--color-primary);
}
</style>
