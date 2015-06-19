# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/kubrick/kubrick-4.14.3.ebuild,v 1.1 2015/06/04 18:44:48 kensington Exp $

EAPI=5

KDE_HANDBOOK="optional"
OPENGL_REQUIRED="always"
inherit kde4-base

DESCRIPTION="A game based on the \"Rubik's Cube\" puzzle"
HOMEPAGE="http://www.kde.org/applications/games/kubrick/"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="$(add_kdeapps_dep libkdegames)
	virtual/glu
"
DEPEND="${RDEPEND}
	virtual/opengl
"
