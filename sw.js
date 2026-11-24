// =====================================================================
// Service Worker básico para Tiquetera Ariel (PWA)
// =====================================================================
// Cachea el App Shell para permitir carga instantánea y funcionamiento offline.
// REGLA FUNDAMENTAL: Las peticiones hacia Supabase (*.supabase.co) y APIs externas
// se dejan pasar directo a la red (network-only) sin interferir con la sincronización
// ni con la lógica local de la aplicación.
// =====================================================================

const CACHE_NAME = 'tiquetera-ariel-v1';
const APP_SHELL = [
  './',
  './index.html',
  './manifest.json',
  './icon.svg',
  './icon-192.png',
  './icon-512.png',
  './apple-touch-icon.png'
];

// Instalación: Cachear recursos estáticos del App Shell
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll(APP_SHELL);
    }).then(() => self.skipWaiting())
  );
});

// Activación: Limpieza de cachés anteriores
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))
      );
    }).then(() => self.clients.claim())
  );
});

// Intercepción de peticiones (Fetch)
self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);

  // 1. REGLA CLAVE: Cualquier petición a Supabase, Webhooks o URLs externas
  // va directo a la red. NO cachear datos de base de datos ni tokens.
  if (url.hostname.includes('supabase.co') || event.request.method !== 'GET') {
    return; // El navegador maneja la petición normalmente por red
  }

  // 2. Recursos del App Shell local: Network-First con fallback a Cache
  event.respondWith(
    fetch(event.request)
      .then(networkResponse => {
        // Si la respuesta es válida, actualizamos la copia en caché de fondo
        if (networkResponse && networkResponse.status === 200 && networkResponse.type === 'basic') {
          const responseToCache = networkResponse.clone();
          caches.open(CACHE_NAME).then(cache => {
            cache.put(event.request, responseToCache);
          });
        }
        return networkResponse;
      })
      .catch(() => {
        // Si no hay red, respondemos con la versión en caché
        return caches.match(event.request).then(cachedResponse => {
          if (cachedResponse) {
            return cachedResponse;
          }
          // Fallback para navegación de página
          if (event.request.mode === 'navigate') {
            return caches.match('./index.html');
          }
          return new Response('Sin conexión', { status: 503, statusText: 'Offline' });
        });
      })
  );
});
