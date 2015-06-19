# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-scroblibre/lc-scroblibre-0.6.70.ebuild,v 1.1 2014/08/03 19:02:39 maksbotan Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="Submissions API 1.2-compliant scrobbler for services like libre.fm"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}"
