# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-lackman/lc-lackman-0.6.70.ebuild,v 1.2 2014/08/14 09:21:36 pinkbyte Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="LeechCraft Package Manager for extensions, scripts, themes etc"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
		>=dev-qt/qtwebkit-4.6:4"
RDEPEND="${DEPEND}
		virtual/leechcraft-downloader-http"
