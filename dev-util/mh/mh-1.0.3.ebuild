# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Generate help for Makefile"
HOMEPAGE="https://github.com/oz123/mh"
SRC_URI="https://github.com/oz123/mh/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT=0

IUSE="test"
KEYWORDS="~amd64"

RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

RDEPEND="dev-libs/libpcre2"

DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )
	"

src_compile() {
	emake mh VERSION="${PV}"
}

src_install() {
	emake install DESTDIR="${D}" PREFIX="/usr"
	dodoc Makefile.example
}
