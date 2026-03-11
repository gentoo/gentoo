# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit toolchain-funcs

MY_PN=CVector
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An ANSI C implementation of dynamic arrays (approximation of C++ vectors)"
HOMEPAGE="http://cvector.sourceforge.net/"
SRC_URI="https://github.com/yayahjb/${PN}/archive/refs/tags/${MY_P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_P}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

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
