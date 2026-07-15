<script setup>
import NavBar from './NavBar.vue'
import FooterSection from './FooterSection.vue'

defineProps({
  currentLang: String,
})

const emit = defineEmits(['toggleLang'])
</script>

<template>
  <NavBar :current-lang="currentLang" @toggle-lang="emit('toggleLang')" />
  <main>
    <router-view v-slot="{ Component }">
      <transition name="fade" mode="out-in">
        <component :is="Component" />
      </transition>
    </router-view>
  </main>
  <FooterSection />
</template>

<style scoped>
main {
  min-height: 100vh;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
