# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KDE_ORG_CATEGORY="office"
KFMIN=6.0.0
QTMIN=6.6.2
MY_P=${P/_beta/b}
inherit ecm kde.org

DESCRIPTION="Latex Editor and TeX shell based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/kile/ https://kile.sourceforge.io/"

if [[ ${KDE_BUILD_TYPE} == release ]]; then
	SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64"
fi

LICENSE="FDL-1.2 GPL-2"
SLOT="0"
IUSE="+pdf +png"

DEPEND="
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	kde-apps/okular:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kdoctools-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	pdf? ( >=app-text/poppler-23.12.0[qt6] )
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
	kde-apps/konsole:6
	kde-apps/okular:6[pdf?]
	virtual/latex-base
	virtual/tex-base
	pdf? (
		app-text/ghostscript-gpl
		app-text/texlive-core
	)
	png? (
		app-text/dvipng
		virtual/imagemagick-tools[png?]
	)
"

DOCS=( kile-remote-control.txt )

PATCHES=( "${FILESDIR}/${PN}-2.9.93_p20221123-cmake.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package pdf Poppler)
	)
	ecm_src_configure
}
