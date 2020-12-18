# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Utility to List Device Vital Product Data (VPD)"
HOMEPAGE="https://github.com/power-ras/lsvpd"
SRC_URI="https://github.com/power-ras/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="ppc64"
IUSE=""

RDEPEND="
	dev-db/sqlite:3
	sys-apps/sg3_utils
	sys-libs/librtas
	sys-libs/libvpd
	sys-libs/zlib
"

DEPEND="${RDEPEND}
	virtual/os-headers
"

BDEPEND=""

src_prepare() {
	default
	eautoreconf
}
