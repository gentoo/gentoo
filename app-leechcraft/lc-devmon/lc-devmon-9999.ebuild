# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="Non-storage USB devices manager for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="
	~app-leechcraft/lc-core-${PV}
	virtual/udev"
RDEPEND="${DEPEND}"
