# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit leechcraft

DESCRIPTION="Submissions API 1.2-compliant scrobbler for services like libre.fm"

SLOT="0"
KEYWORDS=" amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}"
