# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="nginx-rtmp-module"

inherit nginx-module

DESCRIPTION="NGINX-based Media Streaming Server"
HOMEPAGE="https://github.com/arut/nginx-rtmp-module"
SRC_URI="
	https://github.com/arut/nginx-rtmp-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-2"
SLOT="0"

KEYWORDS="amd64 arm64"
