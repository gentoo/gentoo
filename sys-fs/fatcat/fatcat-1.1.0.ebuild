# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="FAT filesystems explore, extract, repair, and forensic tool"
HOMEPAGE="https://github.com/Gregwar/fatcat"
SRC_URI="https://github.com/Gregwar/fatcat/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	cmake-utils_src_install
	doman man/${PN}.1
	dodoc docs/*.md
}
