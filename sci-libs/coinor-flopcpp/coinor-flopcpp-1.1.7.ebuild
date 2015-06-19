# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/coinor-flopcpp/coinor-flopcpp-1.1.7.ebuild,v 1.4 2014/02/04 10:37:08 jlec Exp $

EAPI=5

inherit autotools-utils multilib

MYPN=FlopC++

DESCRIPTION="COIN-OR algebraic modeling language for linear optimization"
HOMEPAGE="https://projects.coin-or.org/FlopC++/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"

RDEPEND="
	sci-libs/coinor-cgl:=
	sci-libs/coinor-clp:=
	sci-libs/coinor-osi:="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )"

S="${WORKDIR}/${MYPN}-${PV}/FlopCpp"

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
		$(use_with doc dot)
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
		doins -r examples
	fi
}
