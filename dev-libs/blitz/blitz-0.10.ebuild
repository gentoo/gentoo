# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils multilib

DESCRIPTION="High-performance C++ numeric library"
HOMEPAGE="http://blitz.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( LGPL-3 Artistic-2 BSD )"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~ppc-macos ~x86-linux ~x86-macos"
IUSE="boost debug doc examples static-libs"

RDEPEND="boost? ( >=dev-libs/boost-1.40 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )"

PATCHES=( "${FILESDIR}"/${P}-{docs,gcc47,set-default-arg-value}.patch )

src_configure() {
	# blas / fortran only needed for benchmarks
	use doc && doxygen -u doc/doxygen/Doxyfile.in
	local myeconfargs=(
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
		--enable-shared
		--disable-cxx-flags-preset
		--disable-fortran
		--without-blas
		$(use_enable boost serialization)
		$(use_enable debug)
		$(use_enable doc doxygen)
		$(use_enable doc html-docs)
		$(use_with boost boost "${EPREFIX}/usr")
		$(use_with boost boost-serialization)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile lib
	use doc && autotools-utils_src_compile info html pdf
}

src_test() {
	pushd ${AUTOTOOLS_BUILD_DIR} > /dev/null
	emake check-testsuite check-examples
	popd > /dev/null
}

src_install () {
	autotools-utils_src_install $(use doc&& echo install-html install-pdf)
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.{cpp,f}
	fi
}
