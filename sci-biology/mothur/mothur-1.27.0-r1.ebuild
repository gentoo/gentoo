# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="A suite of algorithms for ecological bioinformatics"
HOMEPAGE="https://www.mothur.org/"
SRC_URI="https://www.mothur.org/w/images/c/cb/Mothur.${PV}.zip -> ${P}.zip"
S="${WORKDIR}/${PN^}.source"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mpi +readline"

RDEPEND="
	sci-biology/uchime
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-overflows.patch
)

src_configure() {
	use mpi && export CXX=mpicxx || tc-export CXX
	use amd64 && append-cppflags -DBIT_VERSION
}

src_compile() {
	emake \
		USEMPI=$(usex mpi) \
		USEREADLINE=$(usex readline)
}

src_install() {
	dobin mothur
}
