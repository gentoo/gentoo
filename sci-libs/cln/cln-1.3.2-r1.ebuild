# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/cln/cln-1.3.2-r1.ebuild,v 1.10 2013/01/01 08:25:29 ago Exp $

EAPI=4

inherit autotools-utils flag-o-matic

DESCRIPTION="Class library (C++) for numbers"
HOMEPAGE="http://www.ginac.de/CLN/"
SRC_URI="ftp://ftpthep.physik.uni-mainz.de/pub/gnu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"

DEPEND="dev-libs/gmp
	doc? ( virtual/latex-base )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-s390x.patch
	"${FILESDIR}"/${P}-arm.patch
	)

pkg_setup() {
	use sparc && append-cppflags "-DNO_ASM"
	use hppa && append-cppflags "-DNO_ASM"
	use arm && append-cppflags "-DNO_ASM"
}

src_prepare() {
	# avoid building examples
	# do it in Makefile.in to avoid time consuming eautoreconf
	sed -i -e '/^SUBDIRS.*=/s/examples doc benchmarks/doc/' Makefile.in || die
	autotools-utils_src_prepare
}

src_configure () {
	local myeconfargs=( --datadir="${EPREFIX}"/usr/share/doc/${PF} )
	autotools-utils_src_configure
}
src_compile() {
	autotools-utils_src_compile
	use doc && autotools-utils_src_compile html pdf
}

src_install () {
	use doc && DOCS=("${AUTOTOOLS_BUILD_DIR}/doc/cln.pdf") && HTML_DOCS=("${AUTOTOOLS_BUILD_DIR}/doc/")
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.cc
	fi
}
