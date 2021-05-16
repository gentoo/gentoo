# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="MPRIS2 client, written in QML for Plasma 5"
HOMEPAGE="https://github.com/audoban/PlayBar2"
SRC_URI="https://github.com/audoban/PlayBar2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

BDEPEND="kde-frameworks/extra-cmake-modules:5
	kde-frameworks/kdoctools:5"
DEPEND="kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kglobalaccel:5
	kde-frameworks/ki18n:5
	kde-frameworks/kwidgetsaddons:5
	kde-frameworks/kwindowsystem:5
	kde-frameworks/kxmlgui:5
	kde-frameworks/plasma:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-raise_qtquick_to_2_7.patch" )
