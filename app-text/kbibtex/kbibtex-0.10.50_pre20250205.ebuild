# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=b76e7904b8288f001beb4fc0a60a5c66448de85d
ECM_HANDBOOK="optional"
ECM_TEST="true"
PYTHON_COMPAT=( python3_{10..13} )
KFMIN=6.9.0
QTMIN=6.7.2
inherit ecm kde.org optfeature python-any-r1 xdg

DESCRIPTION="BibTeX editor to edit bibliographies used with LaTeX"
HOMEPAGE="https://apps.kde.org/kbibtex/ https://userbase.kde.org/KBibTeX"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="webengine"

RESTRICT="test"

COMMON_DEPEND="
	app-text/poppler[qt6]
	dev-libs/icu:=
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=dev-qt/qtnetworkauth-${QTMIN}:6
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
	${PYTHON_DEPS}
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
"

PATCHES=( "${FILESDIR}"/${P}-cmake.patch ) # bug 949362, pending upstream

src_configure() {
	local mycmakeargs=(
		-DQT_MAJOR_VERSION=6
		$(cmake_use_find_package webengine Qt6WebEngineWidgets)
	)

	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "PDF or PostScript document previews" "kde-apps/okular:6"
	fi
	xdg_pkg_postinst
}
