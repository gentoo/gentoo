# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit leechcraft

DESCRIPTION="Simple HTTP server for Leechcraft"

SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}"
