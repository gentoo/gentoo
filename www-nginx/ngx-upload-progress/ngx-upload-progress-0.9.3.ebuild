# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="nginx-upload-progress-module"
inherit nginx-module

DESCRIPTION="An upload progress system for NGINX monitoring RFC1867 POST uploads"
HOMEPAGE="https://github.com/masterzen/nginx-upload-progress-module"
SRC_URI="
	https://github.com/masterzen/nginx-upload-progress-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Uses custom shell-based tests.
RESTRICT="test"
