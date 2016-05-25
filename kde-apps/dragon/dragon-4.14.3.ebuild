# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="Dragon Player is a simple video player for KDE 4"
HOMEPAGE="https://www.kde.org/applications/multimedia/dragonplayer"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug xine"

RDEPEND="
	media-libs/phonon[qt4]
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"
