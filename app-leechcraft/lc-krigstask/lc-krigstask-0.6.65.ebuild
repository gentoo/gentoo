# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-krigstask/lc-krigstask-0.6.65.ebuild,v 1.1 2014/04/10 17:56:13 maksbotan Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="The taskbar quark for LeechCraft"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdeclarative:4
	x11-libs/libXcomposite"
RDEPEND="${DEPEND}
	 ~virtual/leechcraft-quark-sideprovider-${PV}"
