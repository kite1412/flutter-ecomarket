// Forward to the official worker script hosted on JSDelivr CDN.
// You can alternatively copy the file from the package into your web folder.
// See https://github.com/tekartik/sqflite/tree/master/packages_web/sqflite_common_ffi_web#setup-binaries
// Explicitly set the sqlite3 wasm URL to avoid 404/CORS issues
self.sqlite3WasmUrl = 'https://cdn.jsdelivr.net/npm/sqflite_common_ffi_web@0.4.3/dist/sqlite3.wasm';
importScripts('https://cdn.jsdelivr.net/npm/sqflite_common_ffi_web@0.4.3/dist/sqflite_sw.js');
