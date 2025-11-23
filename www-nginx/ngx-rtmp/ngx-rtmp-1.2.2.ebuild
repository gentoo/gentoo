# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="nginx-rtmp-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

inherit nginx-module

DESCRIPTION="NGINX-based Media Streaming Server"
HOMEPAGE="https://github.com/arut/nginx-rtmp-module"
SRC_URI="
	https://github.com/arut/nginx-rtmp-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"

KEYWORDS="~amd64"
