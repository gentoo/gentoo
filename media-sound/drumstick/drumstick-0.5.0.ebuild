# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fdo-mime gnome2-utils cmake-utils

DESCRIPTION="Qt4/C++ wrapper for ALSA sequencer"
HOMEPAGE="http://drumstick.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dbus doc"

RDEPEND="
	media-libs/alsa-lib
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	x11-misc/shared-mime-info
	dbus? ( dev-qt/qtdbus:4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)"

PATCHES=(
	"${FILESDIR}"/${PV}-doc_automagicness.patch
	"${FILESDIR}"/${PV}-underlinking.patch
	"${FILESDIR}"/${PV}-gcc6-narrowing.patch
)

src_prepare() {
	sed -i \
		-e '/CMAKE_EXE_LINKER_FLAGS/d' \
		CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_DBUS=$(usex dbus)
		-DWITH_DOC=$(usex doc)
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
