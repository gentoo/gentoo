# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/whdd/whdd-9999.ebuild,v 1.1 2012/08/10 14:47:56 maksbotan Exp $

EAPI=4
EGIT_REPO_URI="git://github.com/krieger-od/whdd.git"

inherit cmake-utils git-2

DESCRIPTION="Diagnostic and recovery tool for block devices"
HOMEPAGE="http://github.com/krieger-od/whdd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-util/dialog
	sys-libs/ncurses[unicode]"
RDEPEND="${DEPEND}
	sys-apps/smartmontools"
