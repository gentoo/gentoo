# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic multilib-minimal

DESCRIPTION="Open Fingerprint Architecture"
HOMEPAGE="https://code.google.com/p/musicip-libofa/"
SRC_URI="https://musicip-libofa.googlecode.com/files/${P}.tar.gz"

LICENSE="|| ( APL-1.0 GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/expat
	net-misc/curl
	>=sci-libs/fftw-3.3.3-r2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${P}-gcc-4.patch
	"${FILESDIR}"/${P}-gcc-4.3.patch
	"${FILESDIR}"/${P}-gcc-4.4.patch
	"${FILESDIR}"/${P}-gcc-4.7.patch
)

src_prepare() {
	# disable building non-installed examples
	sed -i -e '/SUBDIRS/s:examples::' Makefile.{am,in} || die

	epatch "${PATCHES[@]}"
	epatch_user

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
	dodoc AUTHORS README
}
