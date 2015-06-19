# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/mothur/mothur-1.13.0-r1.ebuild,v 1.3 2012/08/14 15:37:59 jlec Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="A suite of algorithms for ecological bioinformatics"
HOMEPAGE="http://www.mothur.org/"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
IUSE="mpi +readline"
KEYWORDS="~amd64 ~x86"

DEPEND="${RDEPEND}
	app-arch/unzip"
RDEPEND="mpi? ( virtual/mpi )"

S=${WORKDIR}/Mothur.source

pkg_setup() {
	use mpi && CXX=mpicxx || CXX=$(tc-getCXX)
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-overflows.patch
}

use_yn() {
	use $1 && echo "yes" || echo "no"
}

src_compile() {
	emake USEMPI=$(use_yn mpi) USEREADLINE=$(use_yn readline) || die
}

src_install() {
	dobin ${PN}
}
