# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="A shell script to create the necessary framework to develop KDE applications"
HOMEPAGE="https://www.kde.org/applications/development/kapptemplate"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep krunner '' 5.21.0)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"

RDEPEND="${DEPEND}"

src_install() {
	kde5_src_install
	rm "${ED}"usr/share/kdevappwizard/templates/qml-plasmoid.tar.bz2 || die
	rm "${ED}"usr/share/kdevappwizard/template_previews/runner.png || die
	rm "${ED}"usr/share/kdevappwizard/templates/runner.tar.bz2 || die
}
