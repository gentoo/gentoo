# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/wasteland2/wasteland2-1.3.0.7.ebuild,v 1.2 2015/06/14 17:12:48 ulm Exp $

EAPI=5

inherit eutils gnome2-utils check-reqs games

DESCRIPTION="Direct sequel to 1988's Wasteland, the first-ever post-apocalyptic computer RPG and the inspiration behind the Fallout series"
HOMEPAGE="https://wasteland.inxile-entertainment.com/"
SRC_URI="gog_wasteland_2_${PV}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch mirror"

QA_PREBUILT="${GAMES_PREFIX_OPT}/${PN}/*"

RDEPEND="
	virtual/opengl
	>=dev-libs/atk-2.12.0-r1[abi_x86_32(-)]
	>=dev-libs/glib-2.40.0-r1:2[abi_x86_32(-)]
	>=media-libs/fontconfig-2.10.92:1.0[abi_x86_32(-)]
	>=media-libs/freetype-2.5.3-r1:2[abi_x86_32(-)]
	>=x11-libs/cairo-1.12.16-r2[abi_x86_32(-)]
	>=x11-libs/gdk-pixbuf-2.30.8:2[abi_x86_32(-)]
	>=x11-libs/gtk+-2.24.24:2[abi_x86_32(-)]
	>=x11-libs/pango-1.36.5[abi_x86_32(-)]
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXcursor-1.1.14[abi_x86_32(-)]
	>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
	>=x11-libs/libXrandr-1.4.2[abi_x86_32(-)]
	>=virtual/glu-9.0-r1[abi_x86_32(-)]
"

S="${WORKDIR}/Wasteland 2"

CHECKREQS_DISK_BUILD="22000M"
CHECKREQS_DISK_USR="21600M"

pkg_nofetch() {
	einfo
	einfo "Please buy Wasteland 2"
	einfo "from https://www.gog.com/ and"
	einfo "download \"${SRC_URI}\""
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
	einfo "This ebuild was tested with the CLASSICAL edition."
	einfo "If it works with the deluxe edition too, please"
	einfo "open a bug report. If not, open a bug report too."
	einfo
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	# over 20GB of data
	dodir "${dir}"
	mv game/WL2_Data "${D%%/}${dir}"/ || die
	exeinto "${dir}"
	doexe game/WL2

	games_make_wrapper ${PN} ./WL2 "${dir}"
	newicon -s 256 support/gog-wasteland-2.png ${PN}.png
	make_desktop_entry ${PN} "Wasteland 2"

	dodoc docs/*.pdf

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
