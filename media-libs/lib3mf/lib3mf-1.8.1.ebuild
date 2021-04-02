# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Implementation of the 3D Manufacturing Format file standard"
HOMEPAGE="https://3mf.io/"
SRC_URI="https://github.com/3MFConsortium/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libzip:=
	sys-apps/util-linux
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
	test? ( >=dev-cpp/gtest-1.8.0 )
"

PATCHES=(
	"${FILESDIR}/${P}-0001-Gentoo-specific-avoid-pre-stripping-library.patch"
	"${FILESDIR}/${P}-0002-Add-library-link-dependencies.patch"
	"${FILESDIR}/${P}-0003-Change-installation-include-dir.patch"
	"${FILESDIR}/${P}-0004-Gentoo-specific-Remove-gtest-source-dir.patch"
)

src_configure() {
	local mycmakeargs=(
		-DLIB3MF_TESTS=$(usex test)
		-DUSE_INCLUDED_LIBZIP=OFF
		-DUSE_INCLUDED_ZLIB=OFF
	)
	cmake_src_configure
}

src_install() {
	local DOCS=( CONTRIBUTING.md README.md )
	use doc && DOCS+=( Lib3MF-1.pdf )
	cmake_src_install
}
