# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

MY_PN=CQRlib
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Utility library for quaternion arithmetic / rotation math (ANSI C implemented)"
HOMEPAGE="http://cqrlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/cvector"
DEPEND="${RDEPEND}"

DOCS=( README_CQRlib.txt )
HTML_DOCS=( README_CQRlib.html )
PATCHES=( "${FILESDIR}"/1.0.6-gentoo.patch )

S="${WORKDIR}"/${MY_P}

src_prepare() {
	default
	sed "s:GENTOOLIBDIR:$(get_libdir):g" -i Makefile || die
	append-cflags -std=c90
	append-cxxflags -std=c++98
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		CPPFLAGS="${CXXFLAGS} -DCQR_NOCCODE=1" \
		all
}

src_test() {
	emake -j1 \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		tests
}

src_install() {
	emake -j1 DESTDIR="${ED}" install
	einstalldocs

	find "${D}" -name '*.la' -delete || die
}
