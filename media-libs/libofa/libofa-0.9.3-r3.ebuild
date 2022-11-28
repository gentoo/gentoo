# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="Open Fingerprint Architecture"
HOMEPAGE="https://code.google.com/p/musicip-libofa/"
SRC_URI="https://musicip-libofa.googlecode.com/files/${P}.tar.gz"

LICENSE="|| ( APL-1.0 GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="virtual/pkgconfig"
DEPEND=">=sci-libs/fftw-3.3.3-r2[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-gcc-4{,.3,.4,.7}.patch )

src_prepare() {
	default

	# disable building non-installed examples
	sed -i -e '/SUBDIRS/s:examples::' Makefile.{am,in} || die

	# Force regeneration for Clang 16
	rm aclocal.m4 || die
	eautoreconf
}

src_configure() {
	is-flag -ffast-math && append-flags -fno-fast-math

	multilib-minimal_src_configure
}

multilib_src_configure() {
	# disable dependencies that were used for the noinst_ example only
	ECONF_SOURCE="${S}" econf \
		ac_cv_lib_expat_XML_ExpatVersion=yes \
		ac_cv_lib_curl_curl_global_init=yes \
		--disable-static
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
