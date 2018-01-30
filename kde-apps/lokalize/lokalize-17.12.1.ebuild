# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit python-single-r1 kde5

DESCRIPTION="KDE Applications 5 translation tool"
HOMEPAGE="https://www.kde.org/applications/development/lokalize
http://l10n.kde.org/tools"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kross)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtscript)
	$(add_qt_dep qtsql 'sqlite')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	>=app-text/hunspell-1.2.8:=
"
RDEPEND="${DEPEND}
	dev-python/translate-toolkit[${PYTHON_USEDEP}]
"

pkg_setup() {
	python-single-r1_pkg_setup
	kde5_pkg_setup
}

src_install() {
	kde5_src_install
	python_fix_shebang "${ED}usr/share/${PN}"
}

pkg_postinst() {
	kde5_pkg_postinst

	if ! has_version dev-vcs/subversion ; then
		elog "To be able to autofetch KDE translations in new project wizard, install dev-vcs/subversion."
	fi
}
