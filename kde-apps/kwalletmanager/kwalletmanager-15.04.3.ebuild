# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE Wallet Management Tool"
HOMEAGE="https://www.kde.org/applications/system/kwalletmanager
https://utils.kde.org/projects/kwalletmanager"
KEYWORDS="amd64 x86"
IUSE="debug minimal"

src_install() {
	kde4-base_src_install

	if use minimal ; then
		rm -r "${D}"/usr/share/icons
	fi
}