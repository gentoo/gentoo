# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/ksirk/ksirk-4.14.3.ebuild,v 1.1 2015/06/04 18:44:49 kensington Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE: Ksirk is a KDE port of the board game risk"
HOMEPAGE="
	http://www.kde.org/applications/games/ksirk/
	http://games.kde.org/game.php?game=ksirk
"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	app-crypt/qca:2[qt4(+)]
	$(add_kdeapps_dep libkdegames)
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
