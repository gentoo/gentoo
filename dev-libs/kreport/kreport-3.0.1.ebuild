# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5 python-any-r1

DESCRIPTION="Framework for creation and generation of reports in multiple formats"
[[ ${KDE_BUILD_TYPE} != live ]] && SRC_URI="mirror://kde/stable/${PN}/src/${P}.tar.xz"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="marble +scripting webkit"

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-libs/kproperty
	marble? ( $(add_kdeapps_dep marble '' '' '5=') )
	scripting? ( $(add_qt_dep qtdeclarative) )
	webkit? ( $(add_qt_dep qtwebkit) )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package marble Marble)
		$(cmake-utils_use_find_package webkit Qt5WebKitWidgets)
		-DKREPORT_SCRIPTING=$(usex scripting)
	)
	kde5_src_configure
}
