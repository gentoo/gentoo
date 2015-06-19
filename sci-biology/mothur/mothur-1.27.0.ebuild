# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/mothur/mothur-1.27.0.ebuild,v 1.1 2012/08/14 15:37:59 jlec Exp $

EAPI=4

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="A suite of algorithms for ecological bioinformatics"
HOMEPAGE="http://www.mothur.org/"
SRC_URI="http://www.mothur.org/w/images/c/cb/Mothur.${PV}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
IUSE="mpi +readline"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sci-biology/uchime
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/Mothur.source

pkg_setup() {
	use mpi && export CXX=mpicxx || export CXX=$(tc-getCXX)
	use amd64 && append-flags -DBIT_VERSION
	tc-export FC
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-overflows.patch
}

use_yn() {
	use $1 && echo "yes" || echo "no"
}

src_compile() {
	emake USEMPI=$(use_yn mpi) USEREADLINE=$(use_yn readline)
}

src_install() {
	dobin ${PN}
}
