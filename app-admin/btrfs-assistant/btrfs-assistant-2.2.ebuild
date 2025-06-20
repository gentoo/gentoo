# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg optfeature

DESCRIPTION="GUI management tool to make managing a Btrfs filesystem easier"
HOMEPAGE="https://gitlab.com/btrfs-assistant/btrfs-assistant"
SRC_URI="https://gitlab.com/${PN}/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	dev-qt/qtsvg:6
	sys-fs/btrfs-progs
"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

src_prepare() {
	cmake_src_prepare
	sed -e 's/-Werror //' -i src/CMakeLists.txt || die
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "auto snapshot" app-backup/snapper
	optfeature "auto balance and defrag" sys-fs/btrfsmaintenance
}
