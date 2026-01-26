# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="nginx-vod-module"

inherit nginx-module

DESCRIPTION="NGINX-based MP4 Repackager"
HOMEPAGE="https://github.com/kaltura/nginx-vod-module"
SRC_URI="
	https://github.com/kaltura/nginx-vod-module/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64"

# Uses custom Python-based testing framework.
RESTRICT="test"

DEPEND="
	dev-libs/openssl:=
	dev-libs/libxml2
	media-video/ffmpeg:=
	virtual/zlib:=
	virtual/libiconv
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.33-fix-clock-gettime-config-check.patch"
	"${FILESDIR}/${PN}-1.33-use-prototyped-declaration.patch"
	"${FILESDIR}/${PN}-1.33-fix-ffmpeg-7-avcodec_close.patch" # Bug 965416
)
