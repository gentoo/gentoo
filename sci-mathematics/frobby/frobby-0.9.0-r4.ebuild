# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Software system and project for computations with monomial ideals"
HOMEPAGE="http://www.broune.com/frobby/"
SRC_URI="http://www.broune.com/frobby/frobby_v${PV}.tar.gz"
S="${WORKDIR}/frobby_v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="doc"

RDEPEND="dev-libs/gmp:0=[cxx(+)]"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

PATCHES=(
	"${FILESDIR}"/${PN}-cflags-no-strip-soname.patch
	"${FILESDIR}"/${PN}-gcc-4.7.patch
	"${FILESDIR}"/${PN}-gmp-5.1.patch
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
	emake MODE=shared
	emake MODE=shared library
	use doc && emake docPdf
}

src_install() {
	dobin bin/frobby
	dolib.so bin/libfrobby.so
	dosym libfrobby.so /usr/$(get_libdir)/libfrobby.so.0

	doheader src/frobby.h

	insinto /usr/include/frobby
	doins src/stdinc.h

	use doc && dodoc bin/manual.pdf
}
