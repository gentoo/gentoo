# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Very fast, header only, C++ logging library"
HOMEPAGE="https://github.com/gabime/spdlog"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gabime/spdlog"
else
	SRC_URI="https://github.com/gabime/spdlog/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
fi

LICENSE="MIT"
SLOT="0/1"
IUSE="test"

DEPEND="
	>=dev-libs/libfmt-5.0.0
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.0.0-unbundle-fmt.patch" )

src_configure() {
	rm -r include/spdlog/fmt/bundled || die

	local mycmakeargs=(
		-DSPDLOG_BUILD_EXAMPLES=no
		-DSPDLOG_BUILD_BENCH=no
		-DSPDLOG_BUILD_TESTS=$(usex test)
	)

	cmake-utils_src_configure
}
