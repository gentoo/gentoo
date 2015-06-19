# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/qgit/qgit-2.5.ebuild,v 1.6 2013/06/27 03:29:57 pinkbyte Exp $

EAPI=4

inherit eutils qt4-r2

DESCRIPTION="Qt4 GUI for git repositories"
HOMEPAGE="http://libre.tibirna.org/projects/qgit/wiki/QGit"
SRC_URI="http://libre.tibirna.org/attachments/download/9/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}
	>=dev-vcs/git-1.6
"

S=${WORKDIR}/redivivus

src_install() {
	newbin bin/qgit qgit4
	newicon src/resources/qgit.png qgit4.png
	make_desktop_entry qgit4 QGit qgit4
	dodoc README
}
