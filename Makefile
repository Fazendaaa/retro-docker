all:
	@docker-compose up --build

run:
	@docker run --push 80:8080 fazenda/retro-docker

build:
	@docker buildx build --platform \
	linux/amd64 \
	--push --tag fazenda/retro-docker .

# linux/arm64/v8,\

debug:
	@docker pull fazenda/retro-docker && \
	docker run --rm -it \
	--workdir /test \
	--volume ${PWD}:/test \
	--volume /etc/passwd:/etc/passwd \
	--volume /etc/group:/etc/group \
	--volume /home/$(whoami):/home/$(whoami) \
	--user $(id -g):$(id -g) \
	fazenda/retro-docker \
	/bin/sh
