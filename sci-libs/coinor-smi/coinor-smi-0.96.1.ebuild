# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="COIN-OR Stochastic modelling interface"
HOMEPAGE="https://projects.coin-or.org/Smi/"
SRC_URI="https://github.com/coin-or/Smi/archive/releases/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Smi-releases-${PV}/Smi"

LICENSE="CPL-1.0"
SLOT="0/2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	sci-libs/coinor-clp:=
	sci-libs/coinor-flopcpp:=
	sci-libs/coinor-osi:=
	sci-libs/coinor-utils:="
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )"

src_prepare() {
	default
	# Prevent unneeded call to pkg-config that needs ${ED}'s in path.
	sed -i '/--libs.*addlibs.txt/d' Makefile.in || die
}

src_configure() {
	econf $(use_with doc dot)
}

src_compile() {
	emake all $(usex doc doxydoc '')
}

src_test() {
	# Needed given "make check" is a noop and it skips the working one.
	emake test
}

src_install() {
	default
	dodoc -r examples flopcpp_examples
	use doc && dodoc -r doxydoc/html

	# Duplicate or irrelevant files.
	rm -r "${ED}"/usr/share/coin/doc || die
	find "${ED}" -name '*.la' -delete || die
}
