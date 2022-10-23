# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
KDE_ORG_CATEGORY="office"
KFMIN=5.74.0
QTMIN=5.14.2
inherit ecm kde.org

DESCRIPTION="Latex Editor and TeX shell based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/kile/ https://kile.sourceforge.io/"

if [[ ${KDE_BUILD_TYPE} == release ]]; then
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
	KEYWORDS="amd64 ~arm64 ~riscv x86"
fi

LICENSE="FDL-1.2 GPL-2"
SLOT="5"
IUSE="+pdf +png"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtscript-${QTMIN}:5
	>=dev-qt/qttest-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	kde-apps/okular:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdoctools-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kinit-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	pdf? ( app-text/poppler[qt5] )
"
RDEPEND="${DEPEND}
	kde-apps/konsole:5
	kde-apps/okular:5[pdf?]
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

DOCS=( AUTHORS ChangeLog kile-remote-control.txt README{,.cwl} )

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch"
	"${FILESDIR}/${P}-no-khtml.patch"
	"${FILESDIR}/${P}-fix-crash-when-deleting-templates.patch"
	"${FILESDIR}/${P}-fix-overriding-existing-templates.patch"
	"${FILESDIR}/${P}-fix-ktoolbar-usage.patch"
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package pdf Poppler)
	)
	ecm_src_configure
}
