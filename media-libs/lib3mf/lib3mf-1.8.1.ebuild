# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="implementation of the 3D Manufacturing Format file standard"
HOMEPAGE="http://3mf.io/"
SRC_URI="https://github.com/3MFConsortium/$PN/archive/v$PV.tar.gz -> $P.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
DEPEND=">=dev-cpp/gtest-1.8.0
	dev-libs/libzip
	sys-libs/zlib"
PATCHES="${FILESDIR}/${PN}-system-gtest.patch"
IUSE="test"

src_configure()
{
	local mycmakeargs=(
		"-DLIB3MF_TESTS=$(usex test ON OFF)"
		"-DUSE_INCLUDED_ZLIB=$(usex test ON OFF)"
		"-DUSE_INCLUDED_LIBZIP=$(usex test ON OFF)"
	)
	cmake-utils_src_configure
}
