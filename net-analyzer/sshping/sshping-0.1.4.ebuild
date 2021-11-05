# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="ssh-based ping: measure character echo latency and bandwidth"
HOMEPAGE="https://github.com/spook/sshping"
SRC_URI="https://github.com/spook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-lang/perl"
DEPEND="net-libs/libssh:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fix-man-dir.patch"
	"${FILESDIR}/${P}-respect-cxxflags.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
	)

	cmake_src_configure
}
