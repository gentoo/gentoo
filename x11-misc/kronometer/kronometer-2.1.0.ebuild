# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Stopwatch application"
HOMEPAGE="http://www.aelog.org/kronometer/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"

src_prepare() {
	kde5_src_prepare

	local docdir=doc-translations
	if use_if_iuse handbook && [[ -d ${docdir} ]] ; then
		pushd ${docdir} > /dev/null || die
		for lang in *; do
			if ! has ${lang/_${PN}/} ${LINGUAS} ; then
				cmake_comment_add_subdirectory "${lang}/${PN}"
			fi
		done
		popd > /dev/null || die
	else
		cmake_comment_add_subdirectory ${docdir}
	fi
}
