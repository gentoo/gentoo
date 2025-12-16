# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="nginx-push-stream-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

inherit nginx-module

DESCRIPTION='A pure stream HTTP push technology for your NGINX setup'
HOMEPAGE="https://github.com/wandenberg/nginx-push-stream-module"
SRC_URI="
	https://github.com/wandenberg/nginx-push-stream-module/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64"
