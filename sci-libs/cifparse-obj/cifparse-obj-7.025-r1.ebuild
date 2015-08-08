# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

MY_P="${PN}-v${PV}-prod-src"

DESCRIPTION="Provides an object-oriented application interface to information in mmCIF format"
HOMEPAGE="http://sw-tools.pdb.org/apps/CIFPARSE-OBJ/index.html"
SRC_URI="http://sw-tools.pdb.org/apps/CIFPARSE-OBJ/source/${MY_P}.tar.gz"

LICENSE="PDB"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=""
DEPEND="
	sys-devel/bison
	sys-devel/flex"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-gcc4.3.patch \
		"${FILESDIR}"/${P}-gcc4.7.patch

	sed \
		-e "s:^\(CC=\).*:\1$(tc-getCC):g" \
		-e "s:^\(CCC=\).*:\1$(tc-getCXX):g" \
		-e "s:^\(F77=\).*:\1${FORTRANC}:g" \
		-e "s:^\(F77_LINKER=\).*:\1${FORTRANC}:g" \
		-e "s:-static::g" \
		-i "${S}"/etc/make.* || die "Failed to fix makefile"
}

src_compile() {
	# parallel make fails
	emake -j1
}

src_install() {
	dolib.a lib/*
	insinto /usr/include/${PN}
	doins include/*
}
