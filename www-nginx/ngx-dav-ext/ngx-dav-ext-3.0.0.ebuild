# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="nginx-dav-ext-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

inherit nginx-module

DESCRIPTION="NGINX module providing support for WebDAV PROPFIND,OPTIONS,LOCK,UNLOCK"
HOMEPAGE="https://github.com/arut/nginx-dav-ext-module"
SRC_URI="
	https://github.com/arut/nginx-dav-ext-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"

# Relies on upstream NGINX test framework (https://github.com/nginx/nginx-tests),
# not packaged by Gentoo.
RESTRICT="test"

DEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
"
RDEPEND="${DEPEND}"
