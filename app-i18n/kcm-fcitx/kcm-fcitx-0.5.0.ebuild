# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit kde5

DESCRIPTION="KDE configuration module for Fcitx"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="http://download.fcitx-im.org/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.8
	app-i18n/fcitx-qt5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	$(add_frameworks_dep extra-cmake-modules)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kwidgetsaddons)
	sys-devel/gettext
	x11-libs/libxkbfile"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# po directory is empty, making the build fail
	comment_add_subdirectory po
}
