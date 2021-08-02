# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A Command Line Argument Parser for C++"
HOMEPAGE="https://gitlab.com/argparser/argparser"
SRC_URI="https://gitlab.com/argparser/argparser/-/archive/v1.0.0/argparser-v1.0.0.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"

RDEPEND="dev-libs/libfmt"
DEPEND="${DEPEND}"
BDEPEND="test? ( dev-cpp/gtest )"

S="${WORKDIR}/argparser-v${PV}"

PATCHES=( "${FILESDIR}"/argparser-1.0.0-enable-shared-libs.patch )

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test true false)
	)

	cmake_src_configure
}
