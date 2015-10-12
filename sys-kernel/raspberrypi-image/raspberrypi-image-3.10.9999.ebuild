# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2 versionator

DESCRIPTION="Raspberry PI precompiled kernel and modules"
HOMEPAGE="https://github.com/raspberrypi/firmware"
EGIT_REPO_URI="https://github.com/raspberrypi/firmware.git"
EGIT_PROJECT="raspberrypi-firmware.git"
EGIT_BRANCH="master"

LICENSE="GPL-2 raspberrypi-videocore-bin"
SLOT="${PV}"
KEYWORDS=""
IUSE="doc"

RESTRICT="binchecks strip"

src_install() {
	MY_PV=$(awk '{ print $3 }' extra/uname_string)
	insinto /boot
	local suffix
	for suffix in "" "_emergency" ; do
		newins boot/kernel${suffix}.img kernel-${MY_PV}${suffix}.img
		newins extra/System${suffix}.map System-${MY_PV}${suffix}.map
		newins extra/Module${suffix}.symvers Module-${MY_PV}${suffix}.symvers
	done

	insinto /lib/modules
	doins -r modules/${MY_PV}

	if use doc ; then
		dohtml documentation/ilcomponents/*
	fi
}
