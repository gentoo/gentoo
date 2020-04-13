# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="Searches for song lyrics and displays them in LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="
	~app-leechcraft/lc-core-${PV}
	dev-qt/qtxml:5
"
RDEPEND="${DEPEND}
	virtual/leechcraft-search-show
	virtual/leechcraft-downloader-http
"
