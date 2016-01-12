# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5

DESCRIPTION="ModemManager bindings for Qt"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtdbus:5
	dev-qt/qtxml:5
	net-misc/modemmanager
	!kde-plasma/libmm-qt
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
