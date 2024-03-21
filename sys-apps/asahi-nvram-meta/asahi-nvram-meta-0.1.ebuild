# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Metapackage for asahi-nvram modules"
HOMEPAGE="https://github.com/WhatAmISupposedToPutHere/asahi-nvram"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm64"
IUSE="+bless gui bluetooth raw wifi"

RDEPEND="
	bless? ( sys-apps/asahi-bless )
	gui? ( sys-apps/asahi-startup-disk )
	bluetooth? ( net-misc/asahi-btsync )
	raw? ( sys-apps/asahi-nvram )
	wifi? ( net-misc/asahi-wifisync )
"
