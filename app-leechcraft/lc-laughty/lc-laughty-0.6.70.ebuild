# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-laughty/lc-laughty-0.6.70.ebuild,v 1.1 2014/08/03 18:55:13 maksbotan Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="The LeechCraft notification daemon"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdbus:4"
RDEPEND="${DEPEND}
	virtual/leechcraft-notifier"
