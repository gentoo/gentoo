# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="NetworkManager bindings for Qt"
LICENSE="LGPL-2"
KEYWORDS="amd64 ~arm ~x86"
IUSE="teamd"

RDEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtnetwork)
	|| (
		>=net-misc/networkmanager-0.9.10.0[consolekit,teamd=]
		>=net-misc/networkmanager-0.9.10.0[systemd,teamd=]
	)
	!kde-frameworks/libnm-qt
	!kde-plasma/libnm-qt
	!net-libs/libnm-qt:5
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
