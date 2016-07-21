# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

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
	default
	# as-needed fix
	# hack to avoid eautoreconf (coinor has its own weird autotools)
	sed -i \
		-e 's:\(libAlps_la_LIBADD.*=\).*:\1 @ALPSLIB_LIBS@:g' \
		src/Makefile.in || die
	# bug for later versions of subversions
	sed -i \
		-e 's/xexported/xexported -a "x$svn_rev_tmp" != "xUnversioned directory"/' \
		configure || die
}

src_configure() {
	PKG_CONFIG_PATH+="${ED}"/usr/$(get_libdir)/pkgconfig
	export PKG_CONFIG_PATH
	econf \
		--enable-dependency-linking \
		$(use_with doc dot) \
		$(use_enable static-libs static)
}

src_compile() {
	emake all $(usex doc doxydoc "")
}

src_install() {
	default
	use examples && dodoc -r examples/
	use doc && dodoc -r doxydoc/html/

	prune_libtool_files --all
}
