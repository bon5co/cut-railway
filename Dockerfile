# Cut for Railway.
#
# Cut is a one-process Hono URL shortener that keeps links, click counters and rate-limit counters in Redis
# (REDIS_URL). A stock deploy has two defects for an agent that has to drive it. Every admin write
# (create, edit, delete a link) sent without the session cookie is answered with a 302 redirect to the login page
# instead of a refusal, so a client cannot tell a rejected write from a successful one and no status code proves
# the write path is closed. And the image starts with an empty ADMIN_PASSWORD happily ("not configured" page), which on a
# public domain is a deploy nobody can use. This wrapper makes the three admin POST routes answer 401 when there is
# no valid session (the patch fails the build if its anchors are missing), refuses to start without a strong
# ADMIN_PASSWORD and a REDIS_URL, and binds to every interface so the private network can reach it. The application is
# otherwise untouched.
FROM ghcr.io/mendylanda/cut:0.1.0@sha256:1c1a55388dae38876466d69b00019d0b91ccf5ec193e053fbb15802df7a7807b

USER root
COPY --chmod=0644 patch_admin.mjs /tmp/patch_admin.mjs
RUN node /tmp/patch_admin.mjs /app/dist/server.mjs && rm /tmp/patch_admin.mjs
COPY --chmod=0755 railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
USER node

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
CMD ["node", "dist/server.mjs"]
