# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nginx-module

DESCRIPTION="NGINX-based MP4 Repackager"
HOMEPAGE="https://github.com/kaltura/nginx-vod-module"
SRC_URI+=" https://github.com/kaltura/nginx-vod-module/archive/${MODULE_PV}.tar.gz -> ${PN}-${MODULE_PV}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/libxml2:=
	media-video/ffmpeg:=
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"
