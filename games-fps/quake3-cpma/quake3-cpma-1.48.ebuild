# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MOD_DESC="advanced FPS competition mod"
MOD_NAME="Challenge Pro Mode Arena"
MOD_DIR="cpma"

inherit games games-mods

HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://packages.vstone.eu/quake3/install/cpma${PV//.}-nomaps.zip
	http://packages.vstone.eu/quake3/install/cpma-mappack-full.zip"

LICENSE="all-rights-reserved"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"

src_prepare() {
	mv -f *.pk3 ${MOD_DIR} || die
}

pkg_postinst() {
	games-mods_pkg_postinst
	elog "To enable bots: +bot_enable 1"
}
