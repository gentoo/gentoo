# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit leechcraft

DESCRIPTION="Spellchecking support for LeechCraft"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="~app-leechcraft/lc-core-${PV}
	app-text/hunspell"
RDEPEND="${DEPEND}"
