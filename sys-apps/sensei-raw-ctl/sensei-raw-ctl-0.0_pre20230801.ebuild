# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

MY_COMMIT="e8914c63fbc82832577d9d57f0e87d5fc4de29f9"
DESCRIPTION="SteelSeries Sensei Raw configuration tool"
HOMEPAGE="https://git.janouch.name/p/sensei-raw-ctl"
SRC_URI="https://git.janouch.name/p/sensei-raw-ctl/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"

PATCHES=(
	"${FILESDIR}"/${PN}-0.0_pre20230801-fix_otherflags.patch
)

DEPEND="
	virtual/libusb:1
	gui? (
		dev-libs/glib:2
		x11-libs/gtk+:3
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_GUI=$(usex gui)
	)

	cmake_src_configure
}
