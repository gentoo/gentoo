# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="Provides interfaces and session daemon to colord"
HOMEPAGE="https://projects.kde.org/projects/playground/graphics/colord-kde"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	media-libs/lcms:2
	>=x11-libs/libXrandr-1.3.0
"
RDEPEND="${DEPEND}
	x11-misc/colord
"

PATCHES=( "${FILESDIR}/${P}-cmake34.patch" )

pkg_postinst() {
	kde4-base_pkg_postinst
	if ! has_version "gnome-extra/gnome-color-manager"; then
		elog "You may want to install gnome-extra/gnome-color-manager to add support for"
		elog "colorhug calibration devices."
	fi
}
