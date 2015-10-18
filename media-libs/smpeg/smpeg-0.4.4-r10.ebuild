# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs autotools flag-o-matic multilib-minimal

DESCRIPTION="SDL MPEG Player Library"
HOMEPAGE="http://icculus.org/smpeg/"
SRC_URI="ftp://ftp.lokigames.com/pub/open-source/smpeg/${P}.tar.gz
	mirror://gentoo/${P}-gtkm4.patch.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"
IUSE="X debug cpu_flags_x86_mmx opengl static-libs"

RDEPEND="
	abi_x86_32? (
		!app-emulation/emul-linux-x86-sdl[-abi_x86_32(-)]
		!<=app-emulation/emul-linux-x86-sdl-20140406
	)
	>=media-libs/libsdl-1.2.15-r4[${MULTILIB_USEDEP}]
	opengl? (
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.7.2[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}"

DOCS=( CHANGES README README.SDL_mixer TODO )

src_prepare() {
	epatch "${FILESDIR}"/${P}-m4.patch \
		"${FILESDIR}"/${P}-gnu-stack.patch \
		"${FILESDIR}"/${P}-config.patch \
		"${FILESDIR}"/${P}-PIC.patch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-flags.patch \
		"${FILESDIR}"/${P}-automake.patch \
		"${FILESDIR}"/${P}-mmx.patch \
		"${FILESDIR}"/${P}-malloc.patch \
		"${FILESDIR}"/${P}-format.patch \
		"${FILESDIR}"/${P}-missing-init.patch

	cd "${WORKDIR}"
	epatch "${DISTDIR}"/${P}-gtkm4.patch.bz2
	rm "${S}/acinclude.m4"

	cd "${S}"
	mv configure.in configure.ac || die
	AT_M4DIR="${S}/m4" eautoreconf
}

multilib_src_configure() {
	[[ ${CHOST} == *-solaris* ]] && append-libs -lnsl -lsocket

	# the debug option is bogus ... all it does is add extra
	# optimizations if you pass --disable-debug
	ECONF_SOURCE="${S}" econf \
		--enable-debug \
		--disable-gtk-player \
		$(use_enable static-libs static) \
		$(use_enable debug assertions) \
		$(use_with X x) \
		$(use_enable opengl opengl-player) \
		$(use_enable cpu_flags_x86_mmx mmx)
}

multilib_src_install_all() {
	use static-libs || prune_libtool_files
}
