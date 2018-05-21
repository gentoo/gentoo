# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="A suite of algorithms for ecological bioinformatics"
HOMEPAGE="https://www.mothur.org/"
SRC_URI="https://www.mothur.org/w/images/c/cb/Mothur.${PV}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
IUSE="mpi +readline"
KEYWORDS="amd64 x86"

RDEPEND="
	sci-biology/uchime
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/Mothur.source

pkg_setup() {
	fortran-2_pkg_setup
	use mpi && export CXX=mpicxx || export CXX=$(tc-getCXX)
	use amd64 && append-cppflags -DBIT_VERSION
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-overflows.patch
}

src_compile() {
	emake USEMPI=$(usex mpi) USEREADLINE=$(usex readline)
}

src_install() {
	dobin ${PN}
}
