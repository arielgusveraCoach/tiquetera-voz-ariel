# Tiquetera Ariel — Voz + Manual

Una sola app para cargar tickets sin perder tiempo entre tarea y tarea.

## Cómo usar
- **🎤 Por Voz:** Apretá grabar, contá qué pasó. La app pone fecha/hora REAL.
- **✍️ Manual:** Mismo formulario para escribir a mano.
- **Hora real:** Por defecto usa la hora actual (America/Argentina/Buenos_Aires). Solo cambia si decís "ayer a las 18" y confirmás.
- **Enviar:** Copiar, Mail, WhatsApp.

## Publicar en GitHub Pages
1. En GitHub, crear repo `tiquetera-voz-ariel`
2. Subir `index.html`, `README.md`, `tickets.json` (esta carpeta)
3. Settings > Pages > Branch: main / carpeta / (root) > Save
4. Abrir https://TU-USUARIO.github.io/tiquetera-voz-ariel/

## Nota
Si ya tenés en la carpeta App.tsx / index.css / vfs_manifest.json, son el código React de la versión de Meta AI. No los borres, pero para GitHub Pages el que manda es `index.html`. El `vfs_manifest.json` no hace falta subirlo.

La voz funciona mejor en Chrome con permiso de micrófono. Si no anda, usá modo Manual.
