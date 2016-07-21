# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs autotools multilib-minimal

MY_P=smpeg-${PV}
DESCRIPTION="SDL MPEG Player Library"
HOMEPAGE="http://icculus.org/smpeg/"
SRC_URI="https://dev.gentoo.org/~hasufell/distfiles/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug cpu_flags_x86_mmx static-libs"

DEPEND=">=media-libs/libsdl2-2.0.1-r1[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=( CHANGES README README.SDL_mixer TODO )

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-smpeg2-config.patch

	# avoid file collision with media-libs/smpeg
	sed -i \
		-e '/plaympeg/d' \
		Makefile.am || die

	mv configure.in configure.ac || die
	AT_M4DIR="/usr/share/aclocal acinclude" eautoreconf
}

multilib_src_configure() {
	# the debug option is bogus ... all it does is add extra
	# optimizations if you pass --disable-debug
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		--disable-rpath \
		--enable-debug \
		--disable-sdltest \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable debug assertions)
}

multilib_src_install_all() {
	use static-libs || prune_libtool_files
}
