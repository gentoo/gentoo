# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MOD_DESC="Anime mod with cartoon actors and arcade-like gameplay"
MOD_NAME="Ruin Hunters"
MOD_DIR="ruin"

inherit games games-mods

HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	mirror://quakeunity/modifications/ruinhunters/ruin_hunters_v10.zip
	mirror://quakeunity/modifications/ruinhunters/ruin_hunters_v10a_patch.zip"

LICENSE="freedist"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"

src_prepare() {
	rm -f *.bat
}
