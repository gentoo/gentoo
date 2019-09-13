# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="SiliconDust HDHomeRun Utilties"
HOMEPAGE="https://www.silicondust.com/support/linux/"
SRC_URI="https://download.silicondust.com/hdhomerun/${PN}_${PV}.tgz"

PATCHES=(
	"${FILESDIR}"/dont-strip.patch
)

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
}

src_configure() {
	:
}

src_install() {
	dobin hdhomerun_config
	dolib.so libhdhomerun.so

	insinto /usr/include/hdhomerun
	doins *.h
}
