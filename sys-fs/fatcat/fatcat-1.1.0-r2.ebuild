# Copyright 2018-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="FAT filesystems explore, extract, repair, and forensic tool"
HOMEPAGE="https://github.com/Gregwar/fatcat"
SRC_URI="https://github.com/Gregwar/fatcat/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!elibc_glibc? ( sys-libs/argp-standalone )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/fatcat-include-getopt.patch )

src_install() {
	cmake_src_install
	doman man/${PN}.1
	dodoc docs/*.md
}
