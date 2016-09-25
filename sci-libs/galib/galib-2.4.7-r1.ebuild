# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

MY_PV="${PV//\./}"

DESCRIPTION="Library for genetic algorithms in C++ programs"
HOMEPAGE="http://lancet.mit.edu/ga/"
SRC_URI="http://lancet.mit.edu/ga/dist/galib${MY_PV}.tgz"

LICENSE="BSD examples? ( GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

S="${WORKDIR}/${PN}${MY_PV}"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.7-fix-buildsystem.patch"
	"${FILESDIR}/${PN}-2.4.7-fix-c++14.patch"
	"${FILESDIR}/${PN}-2.4.7-Wformat-security.patch"
)

src_prepare() {
	default
	sed -e "s:/include:${EPREFIX}/usr/include:" \
		-e "s:/lib:${EPREFIX}/usr/$(get_libdir):" \
		-i makevars || die
}

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		lib
	emake -C examples clean
}

src_install() {
	dodir /usr/$(get_libdir)

	use doc && HTML_DOCS+=( doc/. )
	if use examples; then
		dodoc -r examples
		find "${ED%/}/usr/share/doc/${PF}/examples" -iname 'makefile*' -delete || die
		docompress -x /usr/share/doc/${PF}/examples
	fi

	default
}
