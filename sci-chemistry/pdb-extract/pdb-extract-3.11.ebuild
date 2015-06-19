# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/pdb-extract/pdb-extract-3.11.ebuild,v 1.1 2012/06/23 18:57:05 jlec Exp $

EAPI=4

inherit eutils toolchain-funcs multilib prefix

MY_P="${PN}-v${PV}-prod-src"

DESCRIPTION="Tools for extracting mmCIF data from structure determination applications"
HOMEPAGE="http://sw-tools.pdb.org/apps/PDB_EXTRACT/index.html"
SRC_URI="http://sw-tools.pdb.org/apps/PDB_EXTRACT/${MY_P}.tar.gz"

LICENSE="PDB"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="!<app-text/html-xml-utils-5.3"
DEPEND="${RDEPEND}
	>=sci-libs/cifparse-obj-7.025"

S="${WORKDIR}/${MY_P}"

MAKEOPTS+=" -j1"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-cflags-install.patch \
		"${FILESDIR}"/${P}-gcc-4.7.patch \
		"${FILESDIR}"/${PN}-3.004-env.patch

	sed -i \
		-e "s:^\(CCC=\).*:\1$(tc-getCXX):g" \
		-e "s:^\(CC=\).*:\1$(tc-getCC):g" \
		-e "s:^\(GINCLUDES=\).*:\1-I${EPREFIX}/usr/include/cifparse-obj:g" \
		-e "s:^\(LIBDIR=\).*:\1${EPREFIX}/usr/$(get_libdir):g" \
		"${S}"/etc/make.* \
		|| die "Failed to fix makefiles"

	eprefixify pdb-extract-v3.0/Makefile etc/*
}

src_install() {
	exeinto /usr/libexec/ccp4/bin
	doexe bin/pdb_extract{,_sf} bin/extract
	insinto /usr/include/rcsb
	doins include/*
	dodoc README*
	insinto /usr/share/rcsb/
	doins -r pdb-extract-data

	cat >> "${T}"/envd <<- EOF
	PDB_EXTRACT="${EPREFIX}/usr/share/rcsb/"
	PDB_EXTRACT_ROOT="${EPREFIX}/usr/"
	EOF

	newenvd "${T}"/envd 20pdb-extract
}
