# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGIT_COMMIT="af93e7ef17b78dee3e346814731377d5ef7b89f3"
go-module_set_globals

DESCRIPTION="RDAP command line client"
HOMEPAGE="
	https://www.openrdap.org/
	https://github.com/openrdap/rdap
"
SRC_URI="
	https://github.com/openrdap/rdap/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~conikost/distfiles/${P}-deps.tar.gz
"
S="${WORKDIR}/${PN/open/}-${EGIT_COMMIT}"

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
