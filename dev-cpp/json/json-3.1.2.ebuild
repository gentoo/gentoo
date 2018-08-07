# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="JSON for Modern C++"
HOMEPAGE="https://github.com/nlohmann/json"
SRC_URI="https://github.com/nlohmann/json/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

src_configure() {
	local mycmakeargs=(
		-DJSON_BuildTests=OFF
	)
	cmake-utils_src_configure
}
