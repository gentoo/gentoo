# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/faenza-icon-theme/faenza-icon-theme-1.3.ebuild,v 1.3 2013/12/25 09:36:08 maekke Exp $

EAPI=4
inherit gnome2-utils

MY_P=${PN}_${PV}

DESCRIPTION="A scalable icon theme called Faenza"
HOMEPAGE="http://tiheum.deviantart.com/art/Faenza-Icons-173323228"
# Use Ubuntu repo which has a proper faenza-icon-theme tarball
#SRC_URI="http://faenza-icon-theme.googlecode.com/files/${PN}_${PV}.tar.gz"
SRC_URI="http://ppa.launchpad.net/tiheum/equinox/ubuntu/pool/main/${PN:0:1}/${PN}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="minimal"

RDEPEND="!minimal? ( x11-themes/gnome-icon-theme )
	x11-themes/hicolor-icon-theme"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_prepare() {
	local res x
	for x in Faenza Faenza-Dark; do
		for res in 22 24 32 48; do
			cp "${x}"/places/${res}/start-here-gentoo.png \
				"${x}"/places/${res}/start-here.png || die
		done
		cp "${x}"/places/scalable/start-here-gentoo.svg \
			"${x}"/places/scalable/start-here.svg || die
	done
	for x in emesene dockmanager rhythmbox; do
		mv ${x} Faenza-${x} || die
	done
}

src_install() {
	insinto /usr/share/icons
	doins -r Faenza{,-Ambiance,-Dark,-Darker,-Darkest,-dockmanager,-emesene,-Radiance,-rhythmbox}
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
