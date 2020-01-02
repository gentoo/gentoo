# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Very fast, header only, C++ logging library"
HOMEPAGE="https://github.com/gabime/spdlog"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gabime/spdlog"
else
	SRC_URI="https://github.com/gabime/spdlog/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0/1"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/libfmt-5.0.0
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-9999-unbundle-fmt.patch" )

src_configure() {
	rm -r include/spdlog/fmt/bundled || die

	local mycmakeargs=(
		-DSPDLOG_BUILD_EXAMPLE=no
		-DSPDLOG_BUILD_BENCH=no
		-DSPDLOG_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
