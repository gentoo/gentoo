# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-scroblibre/lc-scroblibre-9999.ebuild,v 1.1 2013/12/27 13:58:45 maksbotan Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="Submissions API 1.2-compliant scrobbler for services like libre.fm"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}"
