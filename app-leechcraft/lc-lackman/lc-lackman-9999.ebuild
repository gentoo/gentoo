# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="LeechCraft Package Manager for extensions, scripts, themes etc"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
"
RDEPEND="${DEPEND}
	dev-qt/qtsql:5[sqlite]
	~virtual/leechcraft-downloader-http-${PV}
"
