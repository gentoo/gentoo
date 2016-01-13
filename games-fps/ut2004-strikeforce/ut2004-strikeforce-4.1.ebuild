# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MOD_DESC="a terrorist vs. strike force mod"
MOD_NAME="Strike Force"
MOD_DIR="StrikeForce"

inherit games games-mods

HOMEPAGE="http://www.moddb.com/mods/strike-force-2004"
SRC_URI="https://ut.rushbase.net/beyondunreal/mods/strikeforce-ce-v${PV}.zip"

LICENSE="freedist"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"

src_prepare() {
	rm -f ${MOD_DIR}/*.exe
}
