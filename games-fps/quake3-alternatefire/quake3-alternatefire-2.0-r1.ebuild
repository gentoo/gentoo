# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MOD_DESC="adds unique new secondary attacks to weapons"
MOD_NAME="Alternate Fire"
MOD_DIR="alternatefire"

inherit games games-mods

HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://www.mirrorservice.org/sites/quakeunity.com/modifications/alternatefire/alternatefire-${PV}.zip"

LICENSE="freedist"

KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"
