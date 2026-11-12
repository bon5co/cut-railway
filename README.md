# cut-railway

Thin wrapper over `ghcr.io/mendylanda/cut` (Cut, a self-hosted URL shortener) for the Railway template "Cut".
Answers `401` instead of a `302` redirect on the admin write routes when there is no session, refuses to start
without a 12-character `ADMIN_PASSWORD` or a `REDIS_URL`, and listens on Railway's injected `PORT` on every interface.
Needs a Redis service and `REDIS_URL`.
