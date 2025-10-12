# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ngx_metrics"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

inherit nginx-module

DESCRIPTION="An NGINX module that exports the server's metrics"
HOMEPAGE="https://github.com/liquidm/ngx_metrics"
SRC_URI="
	https://github.com/liquidm/ngx_metrics/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror bindist"

DEPEND="dev-libs/yajl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.1.1-add-dynamic-build-support.patch"
)
