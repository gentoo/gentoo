# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="library for connecting and sending data to icecast servers"
HOMEPAGE="http://www.icecast.org/"
SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="libressl speex static-libs theora"

RDEPEND="
	>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
	>=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}]
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl )
	speex? ( >=media-libs/speex-1.2_rc1-r1[${MULTILIB_USEDEP}] )
	theora? ( >=media-libs/libtheora-1.1.1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/shout/shout.h
)

DOCS=( README examples/example.c )

PATCHES=( "${FILESDIR}"/${PN}-2.4.1-underlinking.patch )

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		$(use_enable theora) \
		$(use_enable speex)
}

multilib_src_install_all() {
	einstalldocs
	rm -rf "${ED}"/usr/share/doc/${PN} || die
	find "${D}" -name '*.la' -delete || die
}
