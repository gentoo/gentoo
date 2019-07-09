# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils flag-o-matic

DESCRIPTION="Class library (C++) for numbers"
HOMEPAGE="https://www.ginac.de/CLN/"
SRC_URI="ftp://ftpthep.physik.uni-mainz.de/pub/gnu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"

RDEPEND="dev-libs/gmp:0="
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

PATCHES=( "${FILESDIR}"/${PN}-1.3.2-arm.patch )

pkg_setup() {
	use sparc && append-cppflags -DNO_ASM
	use hppa && append-cppflags -DNO_ASM
	use arm && append-cppflags -DNO_ASM
}

src_prepare() {
	# avoid building examples
	# do it in Makefile.in to avoid time consuming eautoreconf
	sed -i \
		-e '/^SUBDIRS.*=/s/examples doc benchmarks/doc/' \
		Makefile.in || die
	autotools-utils_src_prepare
}

src_compile() {
	autotools-utils_src_compile
	if use doc; then
		cd "${BUILD_DIR}"
		export VARTEXFONTS="${T}/fonts"
		emake html pdf
		DOCS=("${BUILD_DIR}/doc/cln.pdf")
		HTML_DOCS=("${BUILD_DIR}/doc/")
	fi
}

src_install () {
	autotools-utils_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.cc
	fi
}
