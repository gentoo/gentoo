# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Modern C++ Parallel Task Programming"
HOMEPAGE="https://cpp-taskflow.github.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${P}-gnuinstalldir.patch )

S="${WORKDIR}/taskflow-${PV}"
HTML_DOCS=( docs/. )

src_configure() {
	# TODO: enable CUDA via USE flag
	local mycmakeargs=(
		-DTF_BUILD_CUDA=OFF
		-DTF_BUILD_EXAMPLES=$(usex examples)
		-DTF_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
