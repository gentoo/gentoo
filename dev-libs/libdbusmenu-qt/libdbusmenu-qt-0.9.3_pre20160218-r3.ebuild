# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV/_pre/+16.04.}
inherit cmake

DESCRIPTION="Library providing Qt implementation of DBusMenu specification"
HOMEPAGE="https://launchpad.net/libdbusmenu-qt/"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-cmake{,4}.patch ) # bug 953018

src_prepare() {
	cmake_src_prepare

	cmake_comment_add_subdirectory tools
	# tests fail due to missing connection to dbus
	cmake_comment_add_subdirectory tests
}
