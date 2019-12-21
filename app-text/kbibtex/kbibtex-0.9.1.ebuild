# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="BibTeX editor to edit bibliographies used with LaTeX"
HOMEPAGE="https://userbase.kde.org/KBibTeX"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/KBibTeX/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="5"
IUSE="webengine zotero"

DEPEND="
	app-text/poppler[qt5]
	dev-libs/icu:=
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	virtual/tex-base
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}:5[widgets] )
	zotero? (
		app-crypt/qca[qt5(+)]
		dev-libs/qoauth:5
	)
"
RDEPEND="${DEPEND}
	!app-text/kbibtex:4
	dev-tex/bibtex2html
"

RESTRICT+=" test"

S="${WORKDIR}/${P/_/-}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebKitWidgets=ON
		$(cmake_use_find_package webengine Qt5WebEngineWidgets)
		$(cmake_use_find_package zotero Qca-qt5)
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

	if ! has_version "kde-apps/okular:${SLOT}" ; then
		elog "For PDF or PostScript document preview support, please install kde-apps/okular:${SLOT}"
	fi
}
