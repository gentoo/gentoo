# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2004-fragops/ut2004-fragops-2.20.ebuild,v 1.2 2009/10/10 17:34:13 nyhm Exp $

EAPI=2

MOD_DESC="realism mod"
MOD_NAME="Frag Ops"
MOD_DIR="FragOps"
MOD_ICON="Help/FragOps.ico"

inherit games games-mods

HOMEPAGE="http://www.frag-ops.com/"
SRC_URI="http://www.undercover-gamers.com/Files/FragOps_v${PV/.}_FullLMW.zip"

LICENSE="freedist"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"

src_prepare() {
	rm -f *.TXT ${MOD_DIR}/*.bat
}
