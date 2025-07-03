# Copyright 2018-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="FAT filesystems explore, extract, repair, and forensic tool"
HOMEPAGE="https://github.com/Gregwar/fatcat"
SRC_URI="https://github.com/Gregwar/fatcat/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="!elibc_glibc? ( sys-libs/argp-standalone )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/fatcat-1.1.1-musl-1.2.4-fixes.patch"
)

src_prepare() {
	sed -i -e 's#VERSION 2.8#VERSION 4.0#' CMakeLists.txt || die
	cmake_src_prepare
}

src_install() {
	cmake_src_install
	doman man/${PN}.1
	dodoc docs/*.md
}
