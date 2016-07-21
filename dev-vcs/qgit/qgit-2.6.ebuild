# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils qmake-utils

DESCRIPTION="Qt GUI for git repositories"
HOMEPAGE="http://libre.tibirna.org/projects/qgit"
SRC_URI="http://libre.tibirna.org/attachments/download/12/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	dev-vcs/git
	!dev-vcs/qgit:2
"

S=${WORKDIR}/redivivus-2d0c3b0

src_prepare() {
	default

	# respect CXXFLAGS
	sed -i -e '/CONFIG\s*+=/s/debug_and_release//' \
		-e '/QMAKE_CXXFLAGS.*+=/d' \
		src/src.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	dobin bin/qgit
	doicon src/resources/qgit.png
	make_desktop_entry qgit QGit qgit
	einstalldocs
}
