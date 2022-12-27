import os
from hashlib import sha224
import json
import time

skip = ['node_modules', '.DS_Store', '.last_build_id', '.vscode', 'package.json', 'app.js',
        'package-lock.json', 'manifest.json', 'generator.py', 'favicon.png', 'icons', 'NOTICES', 'flutter_service_worker.js', 'precache-manifest.js', 'service-worker.js']


def revision_generator(file_path, l=21):
    revision = sha224(str(file_path + str(time.time())
                          ).encode('utf-8')).hexdigest()
    if len(revision) > l:
        return revision[:l]
    else:
        return revision


def load_files_recursively(of_dir, current_rel_loc=''):
    files = os.listdir(of_dir)

    results = []

    for file in files:

        if file in skip:
            continue

        abs_loc = f'{of_dir}/{file}'
        rel_loc = f'{current_rel_loc}/{file}'
        if os.path.isdir(abs_loc):
            results.extend(load_files_recursively(abs_loc, rel_loc))
        elif os.path.isfile(abs_loc):
            results.append({
                'revision': revision_generator(abs_loc),
                'url': rel_loc
            })
    return results


if __name__ == '__main__':
    here = os.getcwd()
    res = load_files_recursively(here)
    json_array = json.dumps(res)

    with open(here + '/precache-manifest.js', 'w') as precache_manifest:
        precache_manifest.write(
            f'self.__precacheManifest=(self.__precacheManifest || []).concat({json_array});'
        )

    with open(here + '/service-worker.js', 'w') as service_worker:
        service_worker.write('\
importScripts(\"https://storage.googleapis.com/workbox-cdn/releases/4.3.1/workbox-sw.js\"); \n\
importScripts(\"/precache-manifest.js\");\n\
self.addEventListener(\'message\', (event) => {\n\
    if (event.data && event.data.type === \'SKIP_WAITING\') {\n\
        self.skipWaiting();\n\
    }\n\
});\n\
workbox.core.clientsClaim();\n\
self.__precacheManifest = [].concat(self.__precacheManifest || []);\n\
workbox.precaching.precacheAndRoute(self.__precacheManifest, {});\n\
workbox.routing.registerNavigationRoute(workbox.precaching.getCacheKeyForURL(\"/index.html\"), {\n\
    blacklist: [/^\\/_/,/\\/[^\\/?]+\\.[^\\/]+$/],\n\
});\
')
    with open(here + '/app.js', 'w') as app:
        app.write('\
const handler=require(\'serve-handler\');\
const http=require(\'http\');\
const server=http.createServer((request,response)=>{\
return handler(request,response);\
});\
server.listen(8000);'
                  )
