# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2004-deathball/ut2004-deathball-2.4w.ebuild,v 1.2 2009/10/10 17:33:29 nyhm Exp $

EAPI=2

MOD_DESC="Fast-paced first person sport mod"
MOD_NAME="Deathball"
MOD_DIR="deathball"
MOD_ICON="dbicon.ico"

inherit games games-mods

HOMEPAGE="http://www.deathball.net/"
SRC_URI="http://www.deathball.net/downloads/deathball${PV/.}.zip"

LICENSE="freedist"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"

src_prepare() {
	cd ${MOD_DIR} || die
	mv -f ../*.txt . || die
	rm -f *.bat *.cmd *.db Help/*.db
}
