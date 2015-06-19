# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-rosenthal/lc-rosenthal-9999.ebuild,v 1.1 2014/01/26 17:36:21 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Spellchecking support for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="~app-leechcraft/lc-core-${PV}
	app-text/hunspell"
RDEPEND="${DEPEND}"
