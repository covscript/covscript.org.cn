import { createRouter, createWebHashHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('../views/HomePage.vue'),
  },
  {
    path: '/docs',
    name: 'docs',
    component: () => import('../views/DocsPage.vue'),
  },
  {
    path: '/download',
    name: 'download',
    component: () => import('../views/DownloadPage.vue'),
  },
  {
    path: '/community',
    name: 'community',
    component: () => import('../views/CommunityPage.vue'),
  },
  {
    path: '/blog',
    name: 'blog',
    component: () => import('../views/BlogPage.vue'),
  },
  {
    path: '/playground',
    name: 'playground',
    component: () => import('../views/PlaygroundPage.vue'),
  },
]

const router = createRouter({
  history: createWebHashHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  },
})

export default router
