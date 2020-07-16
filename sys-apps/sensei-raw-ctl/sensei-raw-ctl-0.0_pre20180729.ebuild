# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_COMMIT="175d72ee849afe6e3547739132103cb26acf9173"

inherit cmake-utils

DESCRIPTION="SteelSeries Sensei Raw configuration tool"
HOMEPAGE="https://git.janouch.name/p/sensei-raw-ctl"
SRC_URI="https://git.janouch.name/p/sensei-raw-ctl/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

DEPEND="
	virtual/libusb:1
	gtk? ( x11-libs/gtk+:3 )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_configure() {
	local mycmakeargs=(
		"-DBUILD_GUI=$(usex gtk)"
	)
	cmake-utils_src_configure
}
