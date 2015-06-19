# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/kshisen/kshisen-4.14.3.ebuild,v 1.1 2015/06/04 18:44:44 kensington Exp $

EAPI=5

KDE_HANDBOOK="optional"
KDE_SELINUX_MODULE="games"
inherit kde4-base

DESCRIPTION="A KDE game similiar to Mahjongg"
HOMEPAGE="
	http://www.kde.org/applications/games/kshisen/
	http://games.kde.org/game.php?game=kshisen
"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep libkdegames)
	$(add_kdeapps_dep libkmahjongg)
"
RDEPEND="${DEPEND}"
