# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils libtool multilib-minimal

DESCRIPTION="library for decoding mpeg-2 and mpeg-1 video"
HOMEPAGE="http://libmpeg2.sourceforge.net/"
SRC_URI="http://libmpeg2.sourceforge.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="sdl static-libs X"

RDEPEND="sdl? ( media-libs/libsdl )
	X? (
		x11-libs/libXv
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libXt
	)"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-arm-private-symbols.patch \
		"${FILESDIR}"/${P}-global-symbol-test.patch \
		"${FILESDIR}"/${P}-armv4l.patch
	elibtoolize
	### PowerPC fix for altivec
	epatch "${FILESDIR}"/${P}-altivec.patch
	eautoconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}"	\
	econf \
		$(use_enable static-libs static) \
		--enable-shared \
		$(multilib_native_use_enable sdl) \
		$(multilib_native_use_with X x)

	# remove useless subdirs
	if ! multilib_is_native_abi ; then
		sed -i \
			-e 's/ libvo src//' \
			Makefile || die
	fi
}

multilib_src_compile() {
	emake OPT_CFLAGS="${CFLAGS}" \
		MPEG2DEC_CFLAGS="${CFLAGS}" \
		LIBMPEG2_CFLAGS=""
}

multilib_src_install_all() {
	prune_libtool_files --all
	einstalldocs
}
