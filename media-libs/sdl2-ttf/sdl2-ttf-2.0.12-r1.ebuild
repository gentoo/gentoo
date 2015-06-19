# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl2-ttf/sdl2-ttf-2.0.12-r1.ebuild,v 1.5 2015/04/19 09:49:17 pacho Exp $

EAPI=5
inherit autotools eutils multilib-minimal

MY_P=SDL2_ttf-${PV}
DESCRIPTION="library that allows you to use TrueType fonts in SDL applications"
HOMEPAGE="http://www.libsdl.org/projects/SDL_ttf/"
SRC_URI="http://www.libsdl.org/projects/SDL_ttf/release/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs X"

RDEPEND="X? ( >=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}] )
	>=media-libs/libsdl2-2.0.1-r1[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-linking.patch
	mv configure.in configure.ac || die
	eautoreconf
	rm -r external || die
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		$(use_with X x)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt
	use static-libs || prune_libtool_files
}
