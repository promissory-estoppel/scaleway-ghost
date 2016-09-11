NAME =			ghost
VERSION =		current
VERSION_ALIASES =	0.10.0
TITLE =			Ghost
DESCRIPTION =		Ghost blogging platform
SOURCE_URL =		https://github.com/promissory_estoppel/scaleway-ghost
VENDOR_URL =		https://ghost.org/
DEFAULT_IMAGE_ARCH =	x86_64

IMAGE_VOLUME_SIZE =	50G
IMAGE_BOOTSCRIPT =	stable
IMAGE_NAME =		Ghost 0.10.0


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - https://j.mp/scw-builder | bash
-include docker-rules.mk
