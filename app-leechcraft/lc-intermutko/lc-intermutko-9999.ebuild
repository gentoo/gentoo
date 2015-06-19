# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-intermutko/lc-intermutko-9999.ebuild,v 1.1 2015/02/03 14:38:06 maksbotan Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="Allows one to fine-tune the Accept-Language HTTP header"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}"
