# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Software system and project for computations with monomial ideals"
HOMEPAGE="http://www.broune.com/frobby/"
SRC_URI="http://www.broune.com/frobby/frobby_v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="doc static-libs"

RDEPEND="dev-libs/gmp:0=[cxx]"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

S="${WORKDIR}/frobby_v${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-cflags-no-strip-soname.patch"
	"${FILESDIR}/${PN}-gcc-4.7.patch"
	"${FILESDIR}/${PN}-gmp-5.1.patch"
)

src_prepare() {
	default

	# CXXFLAGS are called CPPFLAGS
	sed "s/CPPFLAGS/CXXFLAGS/" -i Makefile || die
}

src_configure() {
	default
	# Makefile uses the value of CXX which may be defined in /etc/env,
	# breaking cross-compile.
	tc-export CXX
}

src_compile() {
	emake
	MODE=shared emake library
	use static-libs && emake library
	use doc && emake docPdf
}

src_install() {
	dobin bin/frobby
	dolib.so bin/libfrobby.so
	dosym libfrobby.so "${PREFIX}/usr/$(get_libdir)/libfrobby.so.0"
	use static-libs && dolib.a bin/libfrobby.a

	insinto /usr/include
	doins src/frobby.h

	insinto /usr/include/"${PN}"
	doins src/stdinc.h

	use doc && dodoc bin/manual.pdf
}
