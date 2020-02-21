# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit base eutils toolchain-funcs versionator

MY_PN=CVector
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An ANSI C implementation of dynamic arrays (approximation of C++ vectors)"
HOMEPAGE="http://cvector.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${MY_PN}-$(get_version_component_range 1-3)/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-LDFLAGS.patch
	"${FILESDIR}"/1.0.3-dynlib.patch
	)

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		all
}

src_install() {
	ln -sf libCVector.so.$(get_version_component_range 1-3) libCVector.so.$(get_major_version) || die
	ln -sf libCVector.so.$(get_version_component_range 1-3) libCVector.so || die
	dolib.so libCVector.so*

	doheader *.h

	dodoc README_CVector.txt
}
