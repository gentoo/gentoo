# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit leechcraft

DESCRIPTION="Task progress indicator quark for LeechCraft"

SLOT="0"
KEYWORDS=" amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdeclarative:4
	~virtual/leechcraft-quark-sideprovider-${PV}"
RDEPEND="${DEPEND}"
