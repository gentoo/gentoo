# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="The Dylan Programming Language Compiler"
HOMEPAGE="http://www.gwydiondylan.org/"
SRC_URI="x86? ( mirror://gentoo/${P}-x86.tbz2 )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RESTRICT="strip"
LOC="/opt/gwydion-dylan"

DEPEND=""
RDEPEND=">=dev-libs/boehm-gc-6.4"

S="${WORKDIR}"

src_compile() {
	mkdir -p "./${LOC}"
	mv usr/* "./${LOC}"
}

src_install() {
	cp -pr * "${D}"
	doenvd "${FILESDIR}/20gwydion-dylan-bin"
}
