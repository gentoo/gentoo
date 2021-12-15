# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="mimalloc is a compact general purpose allocator with excellent performance"
HOMEPAGE="https://github.com/microsoft/mimalloc"
SRC_URI="https://github.com/microsoft/mimalloc/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
#	"${FILESDIR}"/${PN}-1.7.2-GNUInstallDirs.patch
)

src_configure() {
	local mycmakeargs=(
		# TODO: build hardened variant?
		#-DMI_SECURE=$(usex hardened)

		-DMI_INSTALL_TOPLEVEL=ON
		-DMI_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
