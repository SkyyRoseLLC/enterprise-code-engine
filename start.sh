#!/bin/sh
# Bind to all interfaces and honor Render-provided $PORT; default to 10000
exec uvicorn app:app --host 0.0.0.0 --port ${PORT:-10000}

