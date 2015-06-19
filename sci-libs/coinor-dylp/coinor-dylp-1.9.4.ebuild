# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/coinor-dylp/coinor-dylp-1.9.4.ebuild,v 1.5 2014/02/04 10:15:32 jlec Exp $

EAPI=5

inherit autotools-utils multilib

MYPN=DyLP

DESCRIPTION="COIN-OR using the dynamic simplex linear programming solver"
HOMEPAGE="https://projects.coin-or.org/DyLP/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"

RDEPEND="sci-libs/coinor-osi:="
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
		$(use_with doc dot)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile all $(usex doc doxydoc "")
}

src_test() {
	autotools-utils_src_test test
}

src_install() {
	use doc && HTML_DOC=("${BUILD_DIR}/doxydocs/html/")
	autotools-utils_src_install
	# already installed
	rm "${ED}"/usr/share/coin/doc/${MYPN}/{README,AUTHORS,LICENSE} || die
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
