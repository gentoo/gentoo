# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="false" # Seems broken upstream since kbibtex-cli introduction
ECM_TEST="false"
KFMIN=5.240.0
QTMIN=6.4.0
PYTHON_COMPAT=( python3_{8..13} )
inherit ecm kde.org optfeature python-any-r1

DESCRIPTION="BibTeX editor to edit bibliographies used with LaTeX"
HOMEPAGE="https://apps.kde.org/kbibtex/ https://userbase.kde.org/KBibTeX"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/KBibTeX/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="6"
IUSE="webengine"

RESTRICT="test"

COMMON_DEPEND="
	app-text/poppler[qt6]
	dev-libs/icu:=
	>=dev-qt/qtbase-${QTMIN}[dbus,gui,network,widgets,xml]
	>=dev-qt/qtnetworkauth-${QTMIN}
	>=dev-qt/qt5compat-${QTMIN}
	>=kde-frameworks/kcompletion-${KFMIN}
	>=kde-frameworks/kconfig-${KFMIN}
	>=kde-frameworks/kconfigwidgets-${KFMIN}
	>=kde-frameworks/kcoreaddons-${KFMIN}
	>=kde-frameworks/kcrash-${KFMIN}
	>=kde-frameworks/ki18n-${KFMIN}
	>=kde-frameworks/kiconthemes-${KFMIN}
	>=kde-frameworks/kio-${KFMIN}
	>=kde-frameworks/kitemviews-${KFMIN}
	>=kde-frameworks/kjobwidgets-${KFMIN}
	>=kde-frameworks/kparts-${KFMIN}
	>=kde-frameworks/kservice-${KFMIN}
	>=kde-frameworks/ktexteditor-${KFMIN}
	>=kde-frameworks/ktextwidgets-${KFMIN}
	>=kde-frameworks/kwallet-${KFMIN}
	>=kde-frameworks/kwidgetsaddons-${KFMIN}
	>=kde-frameworks/kxmlgui-${KFMIN}
	virtual/tex-base
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}[widgets] )
"
RDEPEND="${COMMON_DEPEND}
	dev-tex/bibtex2html
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtbase-${QTMIN}[concurrent]
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
		optfeature "PDF or PostScript document previews" "media-gfx/okularpart:5" "kde-apps/okular:5"
	fi
	ecm_pkg_postinst
}
