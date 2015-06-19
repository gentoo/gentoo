# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2004-ultraduel/ut2004-ultraduel-2.1.ebuild,v 1.3 2009/10/09 04:43:03 nyhm Exp $

EAPI=2

MOD_DESC="Improved 1-on-1 deathmatch bot AI"
MOD_NAME="Ultra Duel"

inherit versionator games games-mods

MY_PV=$(replace_version_separator 1 '')
MAIN_FILE="1on1-Ultra-Duel-2K4.zip"
PATCH_FILE="1on1-Ultra-Duel-2K4_Patch${MY_PV}.zip"

HOMEPAGE="http://blitz.unrealplayground.com/ultraduel/"
SRC_URI="http://blitz.unrealplayground.com/downloads/${MAIN_FILE}
	http://blitz.unrealplayground.com/downloads/${PATCH_FILE}"

LICENSE="freedist"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"
