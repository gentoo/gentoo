# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="nginx-push-stream-module"

inherit nginx-module

DESCRIPTION='A pure stream HTTP push technology for your NGINX setup'
HOMEPAGE="https://github.com/wandenberg/nginx-push-stream-module"
SRC_URI="
	https://github.com/wandenberg/nginx-push-stream-module/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64"
