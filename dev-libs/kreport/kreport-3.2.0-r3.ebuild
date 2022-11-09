# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
PYTHON_COMPAT=( python3_{8..11} )
KFMIN=5.82.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org python-any-r1

DESCRIPTION="Framework for creation and generation of reports in multiple formats"
HOMEPAGE="https://community.kde.org/KReport"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/src/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="LGPL-2+"
SLOT="5/4"
IUSE="marble +scripting"

RDEPEND="
	>=dev-libs/kproperty-${PV}:5=
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	marble? ( kde-apps/marble:5= )
	scripting? ( >=dev-qt/qtdeclarative-${QTMIN}:5 )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
"

PATCHES=(
	"${FILESDIR}/${P}-gcc10.patch"
	"${FILESDIR}/${P}-fix-insane-delay.patch"
	"${FILESDIR}/${P}-fix-cmake-config.patch"
	"${FILESDIR}/${P}-Q_REQUIRED_RESULT-placing.patch" # gcc12-patch dep
	"${FILESDIR}/${P}-gcc12.patch"
)

pkg_setup() {
	python-any-r1_pkg_setup
	ecm_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebKitWidgets=ON
		$(cmake_use_find_package marble Marble)
		-DKREPORT_SCRIPTING=$(usex scripting)
	)
	ecm_src_configure
}
