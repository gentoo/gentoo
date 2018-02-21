# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=be912e1b8644053d80e5e37d3ccd07448670fb10
KDE_HANDBOOK="forceoptional"
inherit kde5 vcs-snapshot

DESCRIPTION="Latex Editor and TeX shell based on KDE Frameworks"
HOMEPAGE="https://kile.sourceforge.io/"
SRC_URI="https://github.com/KDE/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="FDL-1.2 GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+pdf +png"

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdoctools)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep khtml)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kinit)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep okular)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtscript)
	$(add_qt_dep qttest)
	$(add_qt_dep qtwidgets)
	pdf? ( app-text/poppler[qt5] )
"
RDEPEND="${DEPEND}
	!app-editors/kile:4
	$(add_kdeapps_dep konsole)
	$(add_kdeapps_dep okular 'pdf?')
	virtual/latex-base
	virtual/tex-base
	pdf? (
		>=app-text/texlive-core-2014
		app-text/ghostscript-gpl
	)
	png? (
		app-text/dvipng
		virtual/imagemagick-tools[png?]
	)
"

DOCS=( kile-remote-control.txt )

src_prepare() {
	kde5_src_prepare

	# I know upstream wants to help us but it doesn't work..
	sed -e '/INSTALL( FILES AUTHORS/s/^/#DISABLED /' \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package pdf Poppler)
	)

	kde5_src_configure
}
