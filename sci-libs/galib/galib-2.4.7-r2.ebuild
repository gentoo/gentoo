# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PV="${PV//\./}"

DESCRIPTION="Library for genetic algorithms in C++ programs"
HOMEPAGE="http://lancet.mit.edu/ga/"
SRC_URI="
	http://lancet.mit.edu/ga/dist/galib${MY_PV}.tgz
	https://dev.gentoo.org/~soap/distfiles/${P}-patches.tar.xz"
S="${WORKDIR}/${PN}${MY_PV}"

LICENSE="BSD examples? ( GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

PATCHES=( "${WORKDIR}"/patches )

src_configure() {
	tc-export AR CXX
	export LIBDIR="${EPREFIX}"/usr/$(get_libdir)
	export INCDIR="${EPREFIX}"/usr/include
}

src_compile() {
	emake lib
	emake -C examples clean
}

src_install() {
	use doc && HTML_DOCS=( doc/. )
	if use examples; then
		dodoc -r examples
		find "${ED}"/usr/share/doc/${PF}/examples -iname 'makefile*' -delete || die
		docompress -x /usr/share/doc/${PF}/examples
	fi

	default
}
