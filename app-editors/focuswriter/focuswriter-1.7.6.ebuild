# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg

DESCRIPTION="Fullscreen and distraction-free word processor"
HOMEPAGE="https://gottcode.org/focuswriter/"
SRC_URI="https://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"
IUSE=""

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	app-text/hunspell:=
	>=dev-qt/qtcore-5.11:5
	>=dev-qt/qtgui-5.11:5
	>=dev-qt/qtmultimedia-5.11:5
	>=dev-qt/qtprintsupport-5.11:5
	dev-qt/qtsingleapplication[qt5(+),X]
	>=dev-qt/qtwidgets-5.11:5
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
"

DOCS=( ChangeLog CREDITS README )

PATCHES=( "${FILESDIR}/${PN}-1.6.0-unbundle-qtsingleapplication.patch" )

src_configure() {
	eqmake5 PREFIX="${EPREFIX}"/usr
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
