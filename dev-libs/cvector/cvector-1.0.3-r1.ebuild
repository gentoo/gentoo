# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cvector/cvector-1.0.3-r1.ebuild,v 1.6 2012/03/01 20:02:17 ranger Exp $

inherit base eutils toolchain-funcs versionator

MY_PN=CVector
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An ANSI C implementation of dynamic arrays to provide a crude approximation to the C++ vector class"
HOMEPAGE="http://cvector.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${MY_P}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PV}-LDFLAGS.patch
	"${FILESDIR}"/${PV}-dynlib.patch
	)

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		all || die
}

src_install() {
	dolib.so *.so.${PV} || die
	dosym libCVector.so.${PV} /usr/$(get_libdir)/libCVector.so.$(get_version_component_range 1-2) || die
	dosym libCVector.so.${PV} /usr/$(get_libdir)/libCVector.so.$(get_major_version) || die
	dosym libCVector.so.${PV} /usr/$(get_libdir)/libCVector.so || die

	insinto /usr/include
	doins *.h || die

	dodoc README_CVector.txt || die
}
