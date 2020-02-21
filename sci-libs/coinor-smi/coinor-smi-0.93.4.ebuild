# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=yes
inherit autotools-utils multilib

MYPN=Smi

DESCRIPTION="COIN-OR Stochastic modelling interface"
HOMEPAGE="https://projects.coin-or.org/Smi/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="CPL-1.0"
SLOT="0/2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-libs/coinor-cbc:=
	sci-libs/coinor-cgl:=
	sci-libs/coinor-clp:=
	sci-libs/coinor-flopcpp:=
	sci-libs/coinor-osi:=
	sci-libs/coinor-utils:="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# needed for the --with-coin-instdir
	dodir /usr
	sed -i \
		-e "s:lib/pkgconfig:$(get_libdir)/pkgconfig:g" \
		configure || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-dependency-linking
		--with-coin-instdir="${ED}"/usr
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	if use doc; then
		cd "${WORKDIR}/${MYPN}-${PV}/doxydoc" || die
		doxygen doxygen.conf || die
	fi
}

src_test() {
	autotools-utils_src_test test
}

src_install() {
	use doc && HTML_DOC=("${WORKDIR}/${MYPN}-${PV}/doxydoc/html/")
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples flopcpp_examples
	fi
}
