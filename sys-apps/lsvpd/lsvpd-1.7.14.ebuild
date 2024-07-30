# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Utility to List Device Vital Product Data (VPD)"
HOMEPAGE="https://github.com/power-ras/lsvpd"
SRC_URI="https://github.com/power-ras/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="ppc64"

RDEPEND="
	dev-db/sqlite:3
	sys-apps/hwdata
	sys-apps/sg3_utils:0=
	sys-libs/librtas
	>=sys-libs/libvpd-2.2.9:=
	sys-libs/zlib
"

DEPEND="${RDEPEND}
	virtual/os-headers
"

BDEPEND=""

PATCHES=( "${FILESDIR}/lsvpd-1.7.14-bashisms.patch" )

src_prepare() {
	default
	eautoreconf
}
