# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="library for connecting and sending data to icecast servers"
HOMEPAGE="https://www.icecast.org/"
SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="speex static-libs theora"

RDEPEND="
	>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
	>=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}]
	dev-libs/openssl:0=
	speex? ( media-libs/speex[${MULTILIB_USEDEP}] )
	theora? ( media-libs/libtheora[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/shout/shout.h
)

src_prepare() {
	default
	# Fix docdir
	sed '/^docdir/s@$(PACKAGE)@$(PF)@' -i Makefile.am || die
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable speex)
		$(use_enable static-libs static)
		$(use_enable theora)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die
}
