# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-sysnotify/lc-sysnotify-0.6.65.ebuild,v 1.1 2014/04/10 18:03:19 maksbotan Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="Notifications via system libnotify daemon for LeechCraft"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdbus:4"
RDEPEND="${DEPEND}"
