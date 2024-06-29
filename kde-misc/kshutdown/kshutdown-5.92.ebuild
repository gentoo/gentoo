# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Shutdown manager for desktop environments like KDE Plasma"
HOMEPAGE="https://kshutdown.sourceforge.io"
SRC_URI="https://downloads.sourceforge.net/${PN}/${PN}-source-${PV}-beta.zip"
S="${WORKDIR}/${P}-beta"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+kde"

DEPEND="
	dev-qt/qtbase:6[dbus,gui,widgets]
	kde? (
		kde-frameworks/kconfig:6
		kde-frameworks/kconfigwidgets:6
		kde-frameworks/kcoreaddons:6
		kde-frameworks/kcrash:6
		kde-frameworks/kdbusaddons:6
		kde-frameworks/kglobalaccel:6
		kde-frameworks/ki18n:6
		kde-frameworks/kidletime:6
		kde-frameworks/knotifications:6
		kde-frameworks/knotifyconfig:6
		kde-frameworks/kstatusnotifieritem:6
		kde-frameworks/kwidgetsaddons:6
		kde-frameworks/kxmlgui:6
	)
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
	|| (
		kde-frameworks/breeze-icons:*
		kde-frameworks/oxygen-icons:*
	)
"
BDEPEND="
	app-arch/unzip
	sys-devel/gettext
	kde? ( kde-frameworks/extra-cmake-modules:0 )
"

src_configure() {
	local mycmakeargs=(
		-DKS_PURE_QT=$(usex !kde)
	)

	cmake_src_configure
}
