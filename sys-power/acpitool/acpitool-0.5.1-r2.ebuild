# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A replacement for the APM tool"
HOMEPAGE="https://packages.debian.org/sid/acpitool"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-ac_adapter.patch
	"${FILESDIR}"/${P}-battery.patch
	"${FILESDIR}"/${P}-kernel3.patch
	"${FILESDIR}"/${P}-wakeup.patch
)
