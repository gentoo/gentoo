# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/coinor-alps/coinor-alps-1.4.9.ebuild,v 1.2 2014/02/04 09:46:38 jlec Exp $

EAPI=5

inherit autotools-utils multilib

MYPN=Alps

DESCRIPTION="COIN-OR Framework for implementing parallel graph search algorithms"
HOMEPAGE="https://projects.coin-or.org/CHiPPS/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="CPL-1.0"
SLOT="0/3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"

RDEPEND="
	sci-libs/coinor-utils:=
	sci-libs/coinor-clp:="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample sci-libs/coinor-cgl )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# as-needed fix
	# hack to avoid eautoreconf (coinor has its own weird autotools)
	sed -i \
		-e 's:\(libAlps_la_LIBADD.*=\).*:\1 @ALPSLIB_LIBS@:g' \
		src/Makefile.in || die
	# bug for later versions of subversions
	sed -i \
		-e 's/xexported/xexported -a "x$svn_rev_tmp" != "xUnversioned directory"/' \
		configure || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-dependency-linking
		$(use_with doc dot)
	)
	PKG_CONFIG_PATH+="${ED}"/usr/$(get_libdir)/pkgconfig \
		autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile all $(usex doc doxydoc "")
}

src_test() {
	autotools-utils_src_test test
}

src_install() {
	use doc && HTML_DOC=("${BUILD_DIR}/doxydocs/html/.")
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
