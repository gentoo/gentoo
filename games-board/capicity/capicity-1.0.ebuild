# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/capicity/capicity-1.0.ebuild,v 1.3 2014/10/12 08:53:13 ago Exp $

EAPI=5
inherit eutils gnome2-utils qmake-utils games

DESCRIPTION="A monopd compatible boardgame to play Monopoly-like games (previously named capitalism)"
HOMEPAGE="http://linux-ecke.de/CapiCity/"
SRC_URI="dedicated? ( mirror://sourceforge/project/capitalism/Capi%20City/${PV}/Capid_${PV}.tar.gz )
	!dedicated? ( mirror://sourceforge/project/capitalism/Capi%20City/${PV}/CapiCity_${PV}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dedicated"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtscript:4
	!dedicated? ( dev-qt/qtgui:4 )"
DEPEND="${RDEPEND}"

src_unpack() {
	default
	S=${WORKDIR}/$(usex dedicated Capid CapiCity)_${PV}
}

src_configure() {
	if use dedicated ; then
		eqmake4 Capid.pro
	else
		eqmake4 CapiCity.pro
	fi
}

src_install() {
	local res

	if use dedicated ; then
		dogamesbin Capid
		dodoc doc/*
	else
		dogamesbin CapiCity
		dodoc changelog README

		for res in 16 22 24 32 48 64; do
			newicon -s ${res} icons/${res}x${res}.png ${PN}.png
		done

		make_desktop_entry CapiCity "Capi City"
	fi
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	use dedicated || gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	use dedicated || gnome2_icon_cache_update
}

pkg_postrm() {
	use dedicated || gnome2_icon_cache_update
}
