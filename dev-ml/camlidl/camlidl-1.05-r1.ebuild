# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/camlidl/camlidl-1.05-r1.ebuild,v 1.2 2014/01/15 23:57:22 bicatali Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="CamlIDL is a stub code generator for using C/C++ libraries from O'Caml"
HOMEPAGE="http://caml.inria.fr/camlidl/"
SRC_URI="http://caml.inria.fr/distrib/bazar-ocaml/${P}.tar.gz"
LICENSE="QPL-1.0 LGPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""
DEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt]"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/tests.patch"
	epatch "${FILESDIR}/includes.patch"
}

src_compile() {
	# Use the UNIX makefile
	libdir=`ocamlc -where`
	sed -i -e "s|OCAMLLIB=.*|OCAMLLIB=${libdir}|" config/Makefile.unix
	sed -i -e "s|BINDIR=.*|BINDIR=${EPREFIX}/usr/bin|" config/Makefile.unix
	ln -s Makefile.unix config/Makefile

	# Make
	emake -j1
}

src_test() {
	einfo "Running tests..."
	cd tests
	emake CCPP="$(tc-getCXX)"
}

src_install() {
	libdir=`ocamlc -where`
	dodir ${libdir#${EPREFIX}}/caml
	dodir /usr/bin
	# Install
	emake BINDIR="${ED}/usr/bin" OCAMLLIB="${D}${libdir}" install

	# Add package header
	sed -e "s/@VERSION/${P}/g" "${FILESDIR}/META.camlidl" >	"${D}${libdir}/META.camlidl" || die

	# Documentation
	dodoc README Changes
}
