# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils libtool multilib-minimal

DESCRIPTION="Library to handle, display and manipulate GIF images"
HOMEPAGE="http://sourceforge.net/projects/giflib/"
SRC_URI="mirror://sourceforge/giflib/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="rle static-libs X"

RDEPEND="
	rle? ( media-libs/urt )
	X? ( >=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140406-r1
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32]
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gif2rle.patch
	epatch "${FILESDIR}"/${P}-giffix-null-Extension-fix.patch
	sed -i '/X_PRE_LIBS/s:-lSM -lICE::' configure || die #483258
	elibtoolize
	epunt_cxx
}

multilib_src_configure() {
	local myconf=()

	# prevent circular depend #111455
	if multilib_is_native_abi && has_version media-libs/urt ; then
		myconf+=( $(use_enable rle) )
	else
		myconf+=( --disable-rle )
	fi

	ECONF_SOURCE=${S} \
	econf \
		--disable-gl \
		$(use_enable static-libs static) \
		$(use_enable X x11) \
		"${myconf[@]}"
}

multilib_src_install_all() {
	# for static libs the .la file is required if build with +rle or +X
	use static-libs || prune_libtool_files --all

	dodoc AUTHORS BUGS ChangeLog NEWS ONEWS README TODO doc/*.txt
	dohtml -r doc
}
