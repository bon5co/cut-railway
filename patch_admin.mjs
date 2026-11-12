// Make the three admin POST routes answer 401 instead of a 302 redirect when the session cookie is missing.
// Fails (non-zero exit, so the image build fails) unless every anchor is found exactly once.
import { readFileSync, writeFileSync } from "node:fs";

const file = process.argv[2];
let src = readFileSync(file, "utf8");

const routes = [
  'admin.post("/admin/links", async (c) => {',
  'admin.post("/admin/links/:slug", async (c) => {',
  'admin.post("/admin/links/:slug/delete", async (c) => {',
];
const before = 'if (!isAuthed()) return c.redirect("/admin");';
const after = 'if (!isAuthed()) return c.text("Unauthorized", 401);';

for (const route of routes) {
  const head = route + "\n  " + before;
  const count = src.split(head).length - 1;
  if (count !== 1) {
    console.error(`patch_admin: anchor for ${route} found ${count} times, expected 1`);
    process.exit(1);
  }
  src = src.replace(head, route + "\n  " + after);
}

writeFileSync(file, src);
console.log(`patch_admin: ${routes.length} routes now answer 401 without a session`);
