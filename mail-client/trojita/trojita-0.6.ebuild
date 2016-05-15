# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

QT4_REQUIRED="4.8.0"
EGIT_REPO_URI="git://anongit.kde.org/${PN}.git"
inherit cmake-utils fdo-mime gnome2-utils qmake-utils virtualx
[[ ${PV} == 9999 ]] && inherit git-r3

DESCRIPTION="A Qt IMAP e-mail client"
HOMEPAGE="http://trojita.flaska.net/"
if [[ ${PV} != 9999 ]]; then
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
IUSE="debug +dbus +password +qt5 test +zlib"

RDEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5[ssl]
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
	)
	!qt5? (
		>=dev-qt/qtbearer-${QT4_REQUIRED}:4
		>=dev-qt/qtcore-${QT4_REQUIRED}:4
		>=dev-qt/qtgui-${QT4_REQUIRED}:4
		>=dev-qt/qtsql-${QT4_REQUIRED}:4[sqlite]
		>=dev-qt/qtwebkit-${QT4_REQUIRED}:4
	)
	dbus? ( dev-qt/qtdbus:5 )
	password? (
		qt5?	( dev-libs/qtkeychain[qt5] )
		!qt5?	( dev-libs/qtkeychain[qt4] )
	)
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
	test? (
		qt5?	( dev-qt/qttest:5 )
		!qt5?	( >=dev-qt/qttest-${QT4_REQUIRED}:4 )
	)
	zlib? ( virtual/pkgconfig )
"

DOCS="README LICENSE"

src_prepare() {
	cmake-utils_src_prepare

	# the build system is taking a look at `git describe ... --dirty` and
	# gentoo's modifications to CMakeLists.txt break these
	sed -i "s/--dirty//" "${S}/cmake/TrojitaVersion.cmake" || die "Cannot fix the version check"

	# ensure correct version of binary is used - bug 544108.
	# this file is only used for qt4 builds
	sed -i "s|\$ENV{QTDIR}/bin|$(qt4_get_bindir) NO_DEFAULT_PATH|" cmake/FindLinguistForTrojita.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DWITH_DBUS=$(usex dbus)
		-DWITH_QT5=$(usex qt5)
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
