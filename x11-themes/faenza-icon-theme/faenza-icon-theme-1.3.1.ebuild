# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit gnome2-utils

MY_P=${PN}_${PV}

DESCRIPTION="A scalable icon theme called Faenza"
HOMEPAGE="http://tiheum.deviantart.com/art/Faenza-Icons-173323228"
# Use Ubuntu repo which has a proper faenza-icon-theme tarball
#SRC_URI="http://faenza-icon-theme.googlecode.com/files/${PN}_${PV}.tar.gz"
SRC_URI="http://ppa.launchpad.net/tiheum/equinox/ubuntu/pool/main/${PN:0:1}/${PN}/${MY_P}.tar.gz"

RESTRICT="binchecks strip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="minimal"

RDEPEND="!minimal? ( x11-themes/gnome-icon-theme )
	x11-themes/hicolor-icon-theme"

S=${WORKDIR}/${PN}-${PV%.*}

src_prepare() {
	local res x
	for x in Faenza Faenza-Dark; do
		for res in 22 24 32 48 64 96; do
			cp "${x}"/places/${res}/start-here-gentoo.png \
				"${x}"/places/${res}/start-here.png || die
		done
		cp "${x}"/places/scalable/start-here-gentoo.svg \
			"${x}"/places/scalable/start-here.svg || die
	done
}

src_install() {
	insinto /usr/share/icons
	doins -r Faenza{,-Ambiance,-Dark,-Darker,-Darkest,-Radiance}

	# TODO: Install to directories where the apps can find them
	# insinto ${somewhere}
	# doins -r emesene dockmanager rhythmbox
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
