# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="An upload progress system for NGINX monitoring RFC1867 POST uploads"
HOMEPAGE="https://github.com/masterzen/nginx-upload-progress-module"

SRC_URI="
	https://github.com/masterzen/nginx-upload-progress-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"
LICENSE="BSD-2"

SLOT=0

MY_PN="nginx-upload-progress-module"
inherit nginx-module

NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"
