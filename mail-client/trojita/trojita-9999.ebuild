# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="git://anongit.kde.org/${PN}.git"
inherit cmake-utils fdo-mime gnome2-utils virtualx
[[ ${PV} == 9999 ]] && inherit git-r3

DESCRIPTION="A Qt IMAP e-mail client"
HOMEPAGE="http://trojita.flaska.net/"
if [[ ${PV} != 9999 ]]; then
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
IUSE="debug +dbus +password test +zlib"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dbus? ( dev-qt/qtdbus:5 )
	password? ( dev-libs/qtkeychain[qt5] )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	test? ( dev-qt/qttest:5 )
	zlib? ( virtual/pkgconfig )
"

DOCS="README LICENSE"

src_prepare() {
	cmake-utils_src_prepare

	# the build system is taking a look at `git describe ... --dirty` and
	# gentoo's modifications to CMakeLists.txt break these
	sed -i "s/--dirty//" "${S}/cmake/TrojitaVersion.cmake" || die "Cannot fix the version check"
}

src_configure() {
	local mycmakeargs=(
		-DWITH_DBUS=$(usex dbus)
		-DWITH_QTKEYCHAINPLUGIN=$(usex password)
		-DWITH_TESTS=$(usex test)
		-DWITH_ZLIB=$(usex zlib)
	)

	cmake-utils_src_configure
}

src_test() {
	virtx cmake-utils_src_test
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
