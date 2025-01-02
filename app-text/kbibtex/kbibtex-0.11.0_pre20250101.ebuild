# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="false" # Seems broken upstream since kbibtex-cli introduction
ECM_TEST="false"
KFMIN=5.240.0
QTMIN=6.4.0
PYTHON_COMPAT=( python3_{8..13} )
KDE_ORG_COMMIT="f15e8cd6fb644679749df4c4974c6a4fc5d2712d" # latest on 2025-01-01
inherit ecm kde.org optfeature python-any-r1

DESCRIPTION="BibTeX editor to edit bibliographies used with LaTeX"
HOMEPAGE="https://apps.kde.org/kbibtex/ https://userbase.kde.org/KBibTeX"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	if [[ -z ${KDE_ORG_COMMIT} ]] ; then
		SRC_URI="mirror://kde/stable/KBibTeX/${PV}/${P}.tar.xz"
	fi
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="webengine"

RESTRICT="test"

COMMON_DEPEND="
	app-text/poppler[qt6]
	dev-libs/icu:=
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=dev-qt/qtnetworkauth-${QTMIN}:6
	>=dev-qt/qt5compat-${QTMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	virtual/tex-base
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}:6[widgets] )
"
RDEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:5
	dev-tex/bibtex2html
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
"
BDEPEND="
	${PYTHON_DEPS}
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WebKitWidgets=ON
		$(cmake_use_find_package webengine Qt6WebEngineWidgets)
	)

	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "PDF or PostScript document previews" "kde-apps/okular:6"
	fi
	ecm_pkg_postinst
}
