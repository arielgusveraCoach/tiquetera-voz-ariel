# 🎟️ Tiquetera Ariel — Voz + Manual (Supabase + PWA)

Aplicación web progresiva (PWA) personal para registrar tickets de soporte técnico mediante dictado por voz o carga manual. Diseñada para operar cómodamente con una sola mano en el celular, con guardado automático en la nube (Supabase) y funcionamiento seguro sin conexión (offline mediante localStorage).

---

## 🚀 Principales Características

- **Uso 100 % personal sin login**: Acceso directo y ágil sin pantallas de inicio de sesión ni trabas de Supabase Auth.
- **Doble motor de conexión (SDK + REST)**: Compatible tanto con las nuevas claves publishable (`sb_publishable_...`) como con las claves legacy anon (`eyJ...`). Si el SDK se bloquea o no carga, la app conmuta automáticamente a llamadas REST nativas.
- **Persistencia y sincronización garantizada**: Al editar tickets se conserva siempre el identificador (`_id`) de Supabase. Si te quedás sin señal, los tickets se guardan de forma segura en el celular y se sincronizan apenas recuperás conexión.
- **Control inteligente de numeración**: El cálculo del siguiente número (`T-001`, `T-002`, etc.) registra el historial máximo para no retroceder ni colisionar con la restricción `unique (numero)` si borrás tickets o tenés huecos.
- **Reconocimiento de voz adaptado a Argentina**:
  - Zona horaria estricta `America/Argentina/Buenos_Aires` (UTC-3): evita que decir *"ayer a las 18"* calcule mal la fecha por culpa del horario UTC.
  - Detección de múltiples equipos en la misma frase (ej. *"Lunix e impresora"* se combinan sin sobreescribirse).
  - Detección automática de sucursales (ej. *"Sucursal La 13"*).
- **Interfaz móvil sin bloqueos**: Se eliminaron los `alert()` y `confirm()` nativos que congelaban el celular. Ahora todo funciona con avisos flotantes (toasts), confirmaciones táctiles limpias y un botón flotante accesible con el pulgar.
- **PWA instalable**: Funciona como aplicación nativa en Android e iPhone con pantalla completa (`standalone`), ícono propio y carga instantánea con Service Worker.

---

## 🛠️ Paso 1: Configurar la base de datos en Supabase

1. Entrá a [supabase.com](https://supabase.com) e iniciá sesión con GitHub.
2. Creá un nuevo proyecto (o seleccioná el existente).
3. En el menú lateral izquierdo, andá a **SQL Editor** > **New query**.
4. Abrí el archivo `Schema-Supabase.sql`, copiá todo su contenido, pegalo en el editor y hacé clic en **Run**.
5. Verificá que te devuelva el registro de prueba `T-001` con éxito.

---

## 🔑 Paso 2: Configurar las claves en `index.html`

Abrí `index.html` y verificá o reemplazá las constantes de conexión:

```javascript
const SUPABASE_URL = "https://TU_PROJECT_REF.supabase.co";
const SUPABASE_ANON_KEY = "sb_publishable_... o eyJ...";
```

> **Nota:** Podés usar indistintamente tu clave publishable moderna (`sb_publishable_...`) de 46 caracteres o la clave legacy anon (`eyJ...`). El sistema adapta los headers automáticamente.

---

## 💻 Paso 3: Cómo probarlo en local

> ⚠️ **Importante:** Por seguridad de los navegadores modernos, tanto el reconocimiento de voz (`SpeechRecognition`) como los `Service Workers` (PWA) **no funcionan abriendo el archivo directamente con doble clic (`file:///...`)**. Necesitan ejecutarse bajo un servidor local (`http://localhost`) o bajo HTTPS.

Podés levantar un servidor local rápido con cualquiera de estas opciones:

### Opción A: Con Node.js / npx (Recomendado)
Abrí una terminal en esta carpeta y ejecutá:
```bash
npx serve .
```
Abrí en tu navegador: `http://localhost:3000`

### Opción B: Con Python
```bash
python -m http.server 8080
```
Abrí en tu navegador: `http://localhost:8080`

### Opción C: Con VS Code
Instalá la extensión **Live Server**, hacé clic derecho sobre `index.html` y elegí **"Open with Live Server"**.

---

## ☁️ Paso 4: Despliegue en Netlify

Netlify te brinda HTTPS gratuito al instante, lo que permite que el micrófono y la instalación PWA funcionen al 100 %.

### Despliegue Manual (Arrastrar y Soltar):
1. Entrá a [app.netlify.com](https://app.netlify.com).
2. Andá a la sección **Sites** (o a tu sitio existente `tablerticketera`).
3. En la pestaña **Deploys**, arrastrá la carpeta completa del proyecto (asegurate de que incluya `index.html`, `manifest.json`, `sw.js` y los íconos PNG y SVG).
4. En pocos segundos el despliegue estará listo en tu URL pública (ej: `https://tablerticketera.netlify.app`).

### Despliegue por Git:
Si tenés el proyecto en GitHub, vinculalo a Netlify y cada `git push` actualizará tu sitio automáticamente.

---

## 📱 Paso 5: Cómo instalarlo como App (PWA) en tu Celular

### En Android (Google Chrome):
1. Abrí la URL de tu app en Chrome (ej: `https://tablerticketera.netlify.app`).
2. Tocá los **tres puntos verticales** arriba a la derecha.
3. Seleccioná **"Instalar aplicación"** o **"Agregar a la pantalla principal"**.
4. Confirmá tocando **Instalar**.
5. ¡Listo! Ya tenés el ícono de la Tiquetera en tu pantalla de inicio y en el cajón de aplicaciones, abriendo en pantalla completa sin barra de direcciones.

### En iPhone (Apple Safari):
1. Abrí la URL de tu app en **Safari** (obligatorio: iOS solo permite instalar PWAs desde Safari).
2. Tocá el botón **Compartir** (el ícono del cuadrado con la flecha apuntando hacia arriba, en el centro de la barra inferior).
3. Deslizá hacia abajo en el menú y tocá **"Agregar a pantalla de inicio"** (*Add to Home Screen*).
4. Tocá **Agregar** arriba a la derecha.
5. ¡Listo! La app queda con su ícono en tu iPhone y funciona como una app nativa independiente.

---

## 🎙️ Micrófono y Dictado por Voz: Diferencias y Limitaciones por SO / Navegador

| Navegador / SO | Soporte de Voz | Comportamiento y Recomendaciones |
| :--- | :---: | :--- |
| **Android (Google Chrome)** | **Excelente (Nativo)** | Soporte total mediante `webkitSpeechRecognition`. Procesa dialecto `es-AR` con gran velocidad y precisión. Pedirá permiso de micrófono la primera vez y lo recordará. |
| **iPhone (Apple Safari)** | **Soportado (con particularidades)** | Apple incorporó `webkitSpeechRecognition` a partir de **iOS 14.5+**. Requiere obligatoriamente HTTPS. Safari suele solicitar permiso de micrófono al inicio de cada sesión. Debe dispararse con un toque explícito en pantalla (no arranca solo). |
| **iPhone (Chrome / Firefox)** | **Limitado** | En iOS, todos los navegadores alternativos usan el motor WebKit de Apple pero con restricciones en APIs experimentales. **Se recomienda usar siempre Safari o la PWA instalada**. |
| **PC / Notebook (Chrome / Edge)** | **Excelente (Nativo)** | Funciona de manera inmediata con cualquier micrófono configurado en Windows/Mac/Linux. |

> 💡 **Consejo de uso en celular:** Si estás en un entorno con mucho ruido o el dictado por voz no capta bien, podés tocar la pestaña **"✍️ Manual"**. El botón **"⏰ Poner hora actual"** rellena fecha y hora con un solo toque sin tener que escribir nada.

---

## 📂 Archivos del Proyecto

- `index.html`: Aplicación principal (interfaz responsiva, lógica de conexión Supabase/REST, reconocimiento de voz y sistema de toasts/modales).
- `Schema-Supabase.sql`: Estructura de tabla `tickets`, índices y políticas RLS públicas para uso personal directo.
- `manifest.json`: Manifiesto de la aplicación web progresiva (nombre, colores, orientación y lista de íconos).
- `sw.js`: Service Worker que cachea el App Shell sin interferir con las peticiones dinámicas a Supabase.
- `icon.svg`, `icon-192.png`, `icon-512.png`, `apple-touch-icon.png`: Íconos optimizados para Android e iOS.
- `README-SUPABASE.md`: Esta documentación.
