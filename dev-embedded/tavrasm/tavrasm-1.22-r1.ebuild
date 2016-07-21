# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs versionator

DESCRIPTION="Compiles code written for Atmels AVR DOS assembler"
HOMEPAGE="http://www.tavrasm.org/"
SRC_URI="mirror://gentoo/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="
	sys-devel/bison
	sys-devel/flex"
RDEPEND=""

S="${WORKDIR}/${PN}.$(delete_all_version_separators ${PV})"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	tc-export CC
	cd src

	# The Makefile of tavrasm is stupid, hence the -j1
	emake -j1 || die "Compilation failed"
}

src_install() {
	dobin src/tavrasm || die "dobin failed"
	doman tavrasm.1
	dodoc README
}
