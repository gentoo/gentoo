# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop gnome2-utils

MY_PN="alienarena-7.66"

DESCRIPTION="Fast-paced multiplayer deathmatch game"
HOMEPAGE="http://red.planetarena.org/"
SRC_URI="http://icculus.org/alienarena/Files/${MY_PN}-linux${PV}.tar.gz
	http://red.planetarena.org/files/${MY_PN}-linux${PV}.tar.gz"

LICENSE="GPL-2 free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated +dga +vidmode +zlib"

UIRDEPEND="
	virtual/jpeg:0
	media-libs/openal
	media-libs/libvorbis
	media-libs/freetype:2
	virtual/glu
	virtual/opengl
	dga? ( x11-libs/libXxf86dga )
	vidmode? ( x11-libs/libXxf86vm )
	zlib? ( sys-libs/zlib )
	net-misc/curl
"
UIDEPEND="
	dga? ( x11-base/xorg-proto )
	vidmode? ( x11-base/xorg-proto )
"
RDEPEND="!dedicated? ( ${UIRDEPEND} )"
DEPEND="${RDEPEND}
	!dedicated? ( ${UIDEPEND} )
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN/_/.}"

PATCHES=( "${FILESDIR}"/${P}-format.patch )

src_configure() {
	econf \
		--with-icondir=/usr/share/icons/hicolor/48x48/apps/ \
		--without-system-libode \
		--disable-documents \
		$(use_enable !dedicated client) \
		$(use_with zlib) \
		$(use_with vidmode xf86vm) \
		$(use_with dga xf86dga)
}

src_install() {
	DOCS="docs/README.txt README" default
	if ! use dedicated ; then
		make_desktop_entry ${PN} "Alien Arena"
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
