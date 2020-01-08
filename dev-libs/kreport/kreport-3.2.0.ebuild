# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_QTHELP="true"
KDE_TEST="true"
PYTHON_COMPAT=( python2_7 python3_{6,7} )
VIRTUALX_REQUIRED="test"
inherit kde5 python-any-r1

DESCRIPTION="Framework for creation and generation of reports in multiple formats"
[[ ${KDE_BUILD_TYPE} != live ]] && SRC_URI="mirror://kde/stable/${PN}/src/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="5/4"
KEYWORDS="amd64 x86"
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
	>=dev-libs/kproperty-3.1.0:5=
	marble? ( $(add_kdeapps_dep marble '' '' '5=') )
	scripting? ( $(add_qt_dep qtdeclarative) )
	webkit? ( >=dev-qt/qtwebkit-5.212.0_pre20180120:5 )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
"

pkg_setup() {
	python-any-r1_pkg_setup
	kde5_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package marble Marble)
		$(cmake_use_find_package webkit Qt5WebKitWidgets)
		-DKREPORT_SCRIPTING=$(usex scripting)
	)
	kde5_src_configure
}
