# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EGIT_REPO_URI="git://github.com/whdd/whdd.git"

inherit eutils git-2

DESCRIPTION="Diagnostic and recovery tool for block devices"
HOMEPAGE="https://whdd.github.io"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-util/dialog
	sys-libs/ncurses[unicode]"
RDEPEND="${DEPEND}
	sys-apps/smartmontools"
