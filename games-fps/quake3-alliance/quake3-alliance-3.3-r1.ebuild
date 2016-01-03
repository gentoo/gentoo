# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MOD_DESC="fast paced, off-handed grapple mod"
MOD_NAME="Alliance"
MOD_DIR="alliance"

inherit games games-mods

HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://quakeunity/modifications/alliance/alliance30.zip
	http://www.superkeff.net/mods/mods/alliance/alliance30.zip
	mirror://quakeunity/modifications/alliance/alliance30-33.zip
	http://www.superkeff.net/mods/mods/alliance/alliance30-33.zip"

LICENSE="freedist"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"

src_prepare() {
	rm -f *.exe
}
