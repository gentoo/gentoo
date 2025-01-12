# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Hard Disk Drive and SSD Health Inspection Tool"
HOMEPAGE="https://gsmartcontrol.shaduri.dev/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ashaduri/gsmartcontrol"
else
	SRC_URI="
		https://github.com/ashaduri/gsmartcontrol/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3 LGPL-3 0BSD Boost-1.0 ZLIB"
#bundles catch2, nlohmann_json, tl_expected and whereami
LICENSE+=" Boost-1.0 CC0-1.0 MIT || ( MIT WTFPL-2 )"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-cpp/glibmm:*
	dev-cpp/gtkmm:3.0
	dev-libs/libsigc++:2
	sys-apps/smartmontools
"
RDEPEND="
	${DEPEND}
	x11-apps/xmessage
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DAPP_BUILD_EXAMPLES=OFF
		-DAPP_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
