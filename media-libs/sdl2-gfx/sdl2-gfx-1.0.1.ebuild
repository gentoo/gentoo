# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl2-gfx/sdl2-gfx-1.0.1.ebuild,v 1.4 2015/03/25 13:47:33 ago Exp $

EAPI=5
inherit autotools eutils multilib-minimal

MY_P="${P/sdl2-/SDL2_}"
DESCRIPTION="Graphics drawing primitives library for SDL2"
HOMEPAGE="http://www.ferzkopp.net/joomla/content/view/19/14/"
SRC_URI="http://www.ferzkopp.net/Software/SDL2_gfx/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc cpu_flags_x86_mmx static-libs"

DEPEND=">=media-libs/libsdl2-2.0.1-r1[video,${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i \
		-e 's/ -O / /' \
		configure.in || die
	mv configure.in configure.ac || die
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	use doc && dohtml -r Docs/html/*
	prune_libtool_files
}
