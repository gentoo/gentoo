# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils multibuild

DESCRIPTION="Qt terminal emulator widget"
HOMEPAGE="https://github.com/lxde/qtermwidget"
SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug qt4 qt5"
REQUIRED_USE="|| ( qt4 qt5 )"

DEPEND="
	qt4? ( dev-qt/designer:4
		dev-qt/qtcore:4
		dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5 )"
RDEPEND="${DEPEND}"

src_prepare() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
	default
}

mb_variantx() {
	if [[ ${MULTIBUILD_VARIANT} == "$1" ]]; then
		echo "${2-ON}"
	else
		echo "${3-OFF}"
	fi
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DBUILD_DESIGNER_PLUGIN="$(mb_variantx qt4)"
			-DUSE_QT5="$(mb_variantx qt5)"
		)
		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
