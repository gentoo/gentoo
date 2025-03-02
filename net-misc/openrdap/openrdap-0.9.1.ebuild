# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

go-module_set_globals

DESCRIPTION="RDAP command line client"
HOMEPAGE="
	https://www.openrdap.org/
	https://github.com/openrdap/rdap
"
SRC_URI="
	https://github.com/openrdap/rdap/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~conikost/distfiles/${P}-vendor.tar.xz
"
S="${WORKDIR}/${PN/open/}-${PV}"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	go build ./cmd/rdap || die
}

src_install() {
	dobin rdap
	einstalldocs
}
