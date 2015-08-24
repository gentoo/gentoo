# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
EGIT_REPO_URI="git://github.com/krieger-od/whdd.git"

inherit cmake-utils git-2

DESCRIPTION="Diagnostic and recovery tool for block devices"
HOMEPAGE="https://github.com/krieger-od/whdd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-util/dialog
	sys-libs/ncurses[unicode]"
RDEPEND="${DEPEND}
	sys-apps/smartmontools"
