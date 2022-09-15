# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/-ac}

DESCRIPTION="WMACPILoad based dockapp to monitor CPU temp and battery time on ACPI kernels"
HOMEPAGE="http://wmacpiload.tuxfamily.org/"
SRC_URI="http://wmacpiload.tuxfamily.org/download/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE="debug"

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm"

DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-acpi-segfault.patch"
	"${FILESDIR}/${PN}-acpi-sys-temp-hwmon.patch"
	"${FILESDIR}/${PN}-acpi-fix-battery-unit.patch"
)

src_configure() {
	econf $(use_enable debug)
}
