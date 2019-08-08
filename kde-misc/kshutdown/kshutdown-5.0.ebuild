# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="false"
KDE_AUTODEPS="false"
inherit kde5

DESCRIPTION="Shutdown manager for desktop environments like KDE Plasma"
HOMEPAGE="https://kshutdown.sourceforge.io"
SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.zip"

LICENSE="GPL-2+"
KEYWORDS="amd64 x86"
IUSE="+kde"

BDEPEND="
	app-arch/unzip
	sys-devel/gettext
	kde? ( kde-frameworks/extra-cmake-modules:5 )
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	kde? (
		kde-frameworks/kconfig:5
		kde-frameworks/kconfigwidgets:5
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kcrash:5
		kde-frameworks/kdbusaddons:5
		kde-frameworks/kglobalaccel:5
		kde-frameworks/ki18n:5
		kde-frameworks/kidletime:5
		kde-frameworks/knotifications:5
		kde-frameworks/knotifyconfig:5
		kde-frameworks/kwidgetsaddons:5
		kde-frameworks/kxmlgui:5
	)
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-cmake-3.15.patch" )

src_configure() {
	local mycmakeargs=(
		-DKS_PURE_QT=$(usex !kde)
	)

	kde5_src_configure
}
