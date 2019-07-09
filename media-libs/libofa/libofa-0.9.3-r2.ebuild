# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib-minimal

DESCRIPTION="Open Fingerprint Architecture"
HOMEPAGE="https://code.google.com/p/musicip-libofa/"
SRC_URI="https://musicip-libofa.googlecode.com/files/${P}.tar.gz"

LICENSE="|| ( APL-1.0 GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

BDEPEND=">=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"
DEPEND=">=sci-libs/fftw-3.3.3-r2[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-gcc-4{,.3,.4,.7}.patch )

src_prepare() {
	default

	# disable building non-installed examples
	sed -i -e '/SUBDIRS/s:examples::' Makefile.{am,in} || die

	is-flag -ffast-math && append-flags -fno-fast-math
}

multilib_src_configure() {
	# disable dependencies that were used for the noinst_ example only
	ECONF_SOURCE=${S} \
	econf \
		ac_cv_lib_expat_XML_ExpatVersion=yes \
		ac_cv_lib_curl_curl_global_init=yes
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -type f -delete || die
}
