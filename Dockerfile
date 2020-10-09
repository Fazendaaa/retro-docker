FROM alpine:3.12 AS BUILDER
LABEL author="fazenda"
LABEL project="retro-docker"

RUN [ "apk", "add", "--no-cache", \
  "ca-certificates==20191127-r4", \
  "nodejs==12.18.3-r0", \
  "p7zip==16.02-r3", \
  "nginx==1.18.0-r0", \
  "sed==4.8-r0", \
  "unzip==6.0-r7", \
  "wget==1.20.3-r1", \
  "xz==5.2.5-r0" \
]

RUN npm install --global coffee-script

WORKDIR /var/www/html

RUN wget https://buildbot.libretro.com/nightly/emscripten/$(date -d "yesterday" '+%Y-%m-%d')_RetroArch.7z
RUN 7z e -y $(date -d "yesterday" '+%Y-%m-%d')_RetroArch.7z 
RUN sed -i '/<script src="analytics.js"><\/script>/d' ./index.html
RUN cp canvas.png media/canvas.png

WORKDIR /var/www/html/assets/frontend

RUN wget https://buildbot.libretro.com/assets/frontend/bundle.zip
RUN unzip bundle.zip -d bundle

WORKDIR /var/www/html

RUN chmod +x indexer
RUN ./indexer > /var/www/html/assets/frontend/bundle/index-xhr
RUN ./indexer > /var/www/html/assets/cores/index-xhr

WORKDIR /var/www/html

RUN rm -rf ./RetroArch.7z
RUN rm -rf ./assets/frontend/bundle.zip

EXPOSE 80

COPY entrepoint.sh .

ENTRYPOINT ./entrypoint.sh
