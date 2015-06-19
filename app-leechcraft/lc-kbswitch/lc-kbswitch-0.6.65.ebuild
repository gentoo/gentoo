# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-kbswitch/lc-kbswitch-0.6.65.ebuild,v 1.1 2014/04/10 17:55:32 maksbotan Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="Provides plugin- or tab-grained keyboard layout control"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}
	x11-apps/setxkbmap"
