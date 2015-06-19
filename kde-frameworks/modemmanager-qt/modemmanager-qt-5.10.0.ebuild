# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/modemmanager-qt/modemmanager-qt-5.10.0.ebuild,v 1.1 2015/05/09 10:36:07 mrueg Exp $

EAPI=5

inherit kde5

DESCRIPTION="ModemManager bindings for Qt"
LICENSE="LGPL-2"
KEYWORDS="~amd64"
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
