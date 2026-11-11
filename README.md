# Gerente de ventas · INDEMO

Tablero estático (un solo `index.html`, sin build) con los indicadores base que pidió Manu para Indemo
(leads recibidos, leads calificados, tiempos de respuesta y cumplimiento de la atención), con la misma estructura del gerente de ventas de Gestalt.

- **Datos:** Kommo `graceindemocommx` (cuenta 36402207), a través del flujo n8n
  `aristoteles - indemo (gerente de ventas: redes con IA + asesoras CDMX/MTY)` (id `DIGzV82ogXDLYMlC`, instancia `digital-crew-n8n.xrzfaj.easypanel.host`).
- **Webhook:** `https://digital-crew-n8n.xrzfaj.easypanel.host/webhook/GERENTE-VENTAS-INDEMO` (constante `WEBHOOK_URL` de `index.html`).
- **Deploy:** `Dockerfile` (nginx:alpine), puerto 80. En EasyPanel: app desde este repo, rama `main`.
- **Dirección:** https://indemo-aristoteles.digitalcrew.com.mx (también responde https://digital-crew-indemo-gerente-ventas.xrzfaj.easypanel.host).
- `flujo-n8n-gerente-ventas-indemo.json`: respaldo del flujo **sin el token de Kommo** (reemplazar `TOKEN_DE_KOMMO` en el nodo `Config4` si se importa).

## Dos secciones, cargadas juntas (sin botón de cambio)
La IA (Valentina) solo atiende **redes sociales** (Instagram y Facebook). Por eso el tablero tiene dos secciones, una debajo de la otra, que se cargan al mismo tiempo con un solo «Generar reporte completo». Primero CDMX y MTY (asesoras); todo lo de la IA va al final de la página:

| Sección | Embudos | Qué mide |
|---|---|---|
| **Redes sociales (con IA)** | LEADS REDES SOCIALES | Lo que la IA recibe y **delega** a las asesoras (primera vez que un lead llega a CALIFICADO), y qué tan rápido lo atienden. A la IA no se la audita: solo se muestra cuánto recibió. |
| **CDMX y MTY (asesoras)** | LEADS CDMX y LEADS MTY | Todo corresponde a las asesoras: leads que nacen en esos embudos (sin los que pasó la IA), tiempo de respuesta, avance, vivos. |

Cada sección trae sus propios bloques: leads, desempeño y atención / tiempo de respuesta (con la lista de leads sin atender y su historial).
Entre las dos secciones van los bloques compartidos de todos los embudos: inscritos con comparativo, canales (nuevos de CDMX/MTY más delegados por la IA), el listado de **leads calificados** (CALIFICADO en redes; de cita en campus a inicio de proceso de pago en CDMX y MTY, con exportar a CSV) y la actividad diaria. Sin tablas de «oportunidades calientes» ni de «leads vivos» y sin «JSON crudo» (se quitaron el 11-nov a pedido de Josué).
Si en los filtros se eligen embudos, cada sección solo aparece si incluye alguno de los suyos. **Inscritos** y su comparativo cuentan todos los embudos (un lead que la IA delega se inscribe ya en CDMX o MTY).

## Cómo se define cada cosa
| Qué | Dónde |
|---|---|
| Etapas: cita = «cita en campus», proceso de pago = «inicio de proceso de pago», inscrito = 142 «inscrito» + «pago realizado» (CDMX), perdido = 143 | nodo `Config Mapeo2` del flujo |
| Etapas «calientes» (de cita en campus a inicio de proceso de pago; en redes, CALIFICADO) | `calientes` en `Config Mapeo2` |
| «Largo plazo» queda fuera de la escalera de avance (es una espera, no un avance) | `stage_order` en `Config Mapeo2` |
| Canales (etiquetas de Kommo → canal; la primera coincidencia gana) | `canales` en `Config Mapeo2` |
| Usuarios que no son asesoras (Diana Amezcua inactiva, Marketing INDEMO) y leads de prueba | `usuarios_excluidos` y `leads_excluidos` en `Config Mapeo2` |
| Plazo para «sin atender» (24 h), historial que se revisa, horario laboral (lunes a viernes 9–18, UTC-6) | `umbral_sin_atender_horas`, `lookback_dias` y `horario` en `Config Mapeo2` |
| Metas mensuales de leads por embudo | `METAS_MENSUALES` en `index.html` (hoy vacío: **pendiente de definir**) |

## Qué cuenta como «atendido»
Una **persona** hizo algo después de la entrega (IA) o del nacimiento del lead (asesoras): mandó un WhatsApp, hizo una llamada, escribió una nota, completó una tarea o movió la etapa.
Los mensajes del bot y las automatizaciones (`created_by = 0`) no cuentan. Se mide el **primer toque** (cualquier acción) y el **primer mensaje o llamada**, en horas de lunes a viernes 9–18 y también en tiempo corrido.

## Cosas que conviene saber
- Todo el equipo de Indemo usa pocos usuarios de Kommo (Graciela Trueba y Burgo Monterrey), así que «por asesora» es en realidad por usuario; lo que se escribe fuera de Kommo no se ve.
- En MTY las etapas de sistema 142 y 143 se llaman las dos «pago realizado (inscrito)» en Kommo; el tablero las trata por lo que son (inscrito y perdido).
- **Citas programadas** (tareas de tipo Reunión) salen en 0: Indemo no usa ese tipo de tarea (usa «Follow-up» y «Llamada») sino las etapas «cita en campus» y «asistió a visita».
- **Monto / ticket promedio:** salen del campo Venta del lead; solo algunos leads lo traen.
- Para periodos con más de 1,000 leads nuevos solo se revisa la atención de los 1,000 más recientes (se avisa en pantalla).
- **Seguridad:** el webhook es público (igual que los demás tableros) y devuelve nombres de leads. Si el tablero se va a compartir fuera del equipo, conviene protegerlo con una clave.
