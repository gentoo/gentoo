# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=d9ff4c17d052c8d1bb648402e88d70d77897f847
EGIT_BRANCH="frameworks"
KDE_HANDBOOK="forceoptional"
inherit kde5 vcs-snapshot

DESCRIPTION="Application to generate publication-ready figures"
HOMEPAGE="https://wwwu.uni-klu.ac.at/magostin/cirkuit.html"
[[ ${KDE_BUILD_TYPE} = live ]] || \
SRC_URI="https://github.com/KDE/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	app-text/poppler[qt5]
"
RDEPEND="${DEPEND}
	app-text/ghostscript-gpl
	app-text/ps2eps
	dev-texlive/texlive-pstricks
	media-gfx/dpic
	media-gfx/pdf2svg
	media-libs/netpbm
	virtual/latex-base
"

DOCS=( Changelog README )
