# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="Framework for syntax highlighting"
LICENSE="LGPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtxmlpatterns)
"
DEPEND="${RDEPEND}
	dev-lang/perl
	test? ( $(add_qt_dep qtwidgets) )
"

src_install() {
	kde5_src_install
	dobin "${BUILD_DIR}"/src/indexer/katehighlightingindexer
}
