# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="ModemManager bindings for Qt"
LICENSE="LGPL-2"
KEYWORDS="amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtxml)
	net-misc/modemmanager
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

# requires running environment
RESTRICT+=" test"
