# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Very fast, header only, C++ logging library."
HOMEPAGE="https://github.com/gabime/spdlog"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gabime/spdlog"
else
	SRC_URI="https://github.com/gabime/spdlog/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
			-DSPDLOG_BUILD_EXAMPLES=no
			-DSPDLOG_BUILD_TESTING=$(usex test)
	)

	cmake-utils_src_configure

}
