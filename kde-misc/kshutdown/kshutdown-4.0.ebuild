# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils gnome2-utils

MY_P=${PN}-source-${PV/_}

DESCRIPTION="A shutdown manager for KDE"
HOMEPAGE="http://kshutdown.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kdbusaddons:5
	kde-frameworks/kglobalaccel:5
	kde-frameworks/ki18n:5
	kde-frameworks/kidletime:5
	kde-frameworks/knotifications:5
	kde-frameworks/knotifyconfig:5
	kde-frameworks/kwidgetsaddons:5
	kde-frameworks/kxmlgui:5
	!kde-misc/kshutdown:4
"
DEPEND="${RDEPEND}
	app-arch/unzip
	kde-frameworks/extra-cmake-modules:5
	sys-devel/gettext
"

src_configure() {
	local mycmakeargs=(
		-DKS_KF5=TRUE
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
