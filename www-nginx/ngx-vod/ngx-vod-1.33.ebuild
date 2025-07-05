# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="nginx-vod-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

inherit nginx-module

DESCRIPTION="NGINX-based MP4 Repackager"
HOMEPAGE="https://github.com/kaltura/nginx-vod-module"
SRC_URI="
	https://github.com/kaltura/nginx-vod-module/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Uses custom Python-based testing framework.
RESTRICT="test"

DEPEND="
	dev-libs/openssl:=
	dev-libs/libxml2
	media-video/ffmpeg:=
	sys-libs/zlib:=
	virtual/libiconv
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.33-fix-clock-gettime-config-check.patch"
)
