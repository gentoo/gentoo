# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN=CVector
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An ANSI C implementation of dynamic arrays (approximation of C++ vectors)"
HOMEPAGE="http://cvector.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${PN}/${MY_PN}-$(ver_cut 1-3)/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=(
	"${FILESDIR}"/${P}-LDFLAGS.patch
	"${FILESDIR}"/1.0.3-dynlib.patch
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" \
		all
}

src_install() {
	ln -sf libCVector.so.$(ver_cut 1-3) libCVector.so.$(ver_cut 1) || die
	ln -sf libCVector.so.$(ver_cut 1-3) libCVector.so || die

	dolib.so libCVector.so*
	doheader *.h

	dodoc README_CVector.txt
}
