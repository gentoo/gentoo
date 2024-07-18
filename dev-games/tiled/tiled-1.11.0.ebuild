# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A general purpose tile map editor"
HOMEPAGE="https://www.mapeditor.org/"
SRC_URI="https://github.com/bjorn/tiled/archive/v${PV}/${P}.tar.gz"

LICENSE="BSD BSD-2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="clang"

RDEPEND="
	app-arch/zstd
	dev-qt/qtbase:6[X]
	dev-qt/qtimageformats:6
	dev-qt/qtdeclarative:6
	dev-qt/qtwayland:6
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-util/qbs
"

src_configure() {
	qbs setup-qt /usr/bin/qmake6 qt6 || die
	qbs config defaultProfile qt6 || die

	if use clang; then
		qbs setup-toolchains clang clang || die
		qbs config profiles.qt6.baseProfile clang || die
	else
		qbs setup-toolchains gcc gcc || die
		qbs config profiles.qt6.baseProfile gcc || die
	fi

	qbs qbs.installPrefix:"/usr" projects.Tiled.installHeaders:true || die
}

src_install() {
	qbs install --install-root "${D}" || die
	mkdir --parents ${D}/usr/$(get_libdir)
	mv ${D}/usr/lib/libtiled.so ${D}/usr/$(get_libdir)/libtiled.so || die
	mv ${D}/usr/lib/libtilededitor.so ${D}/usr/$(get_libdir)/libtilededitor.so || die
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

