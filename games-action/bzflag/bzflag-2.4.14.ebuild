# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop flag-o-matic ltprune

DESCRIPTION="3D tank combat simulator game"
HOMEPAGE="https://www.bzflag.org/"
SRC_URI="https://download.bzflag.org/bzflag/source/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated upnp"

RDEPEND="
	net-dns/c-ares
	>=net-misc/curl-7.15.0
	sys-libs/ncurses:0
	sys-libs/zlib
	!dedicated? (
		media-libs/libsdl2[joystick,sound,video]
		virtual/glu
		virtual/opengl )
	upnp? ( net-libs/miniupnpc )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.4.12-configure.patch
	"${FILESDIR}"/${PN}-2.4.12-tinfo.patch
	"${FILESDIR}"/${PN}-2.4.12-sdl2-cppflags.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable upnp UPnP)
		--libdir="${EPREFIX}"/usr/$(get_libdir)/${PN}
	)

	if use dedicated ; then
		ewarn
		ewarn "You are building a server-only copy of BZFlag"
		ewarn
		myconf+=( --disable-client --without-SDL )
	else
		myconf=( --with-SDL=2 )
	fi

	econf "${myconf[@]}"
}

src_install() {
	DOCS="AUTHORS ChangeLog DEVINFO PORTING README README.Linux" \
		default

	if ! use dedicated ; then
		newicon data/bzflag-48x48.png ${PN}.png
		make_desktop_entry ${PN} "BZFlag"
	fi

	prune_libtool_files --modules
}
