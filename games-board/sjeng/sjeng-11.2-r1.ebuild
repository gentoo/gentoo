# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/sjeng/sjeng-11.2-r1.ebuild,v 1.8 2014/10/09 09:54:29 ago Exp $

EAPI=5
inherit games

DESCRIPTION="Console based chess interface"
HOMEPAGE="http://sjeng.sourceforge.net/"
SRC_URI="mirror://sourceforge/sjeng/Sjeng-Free-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

DEPEND="sys-libs/gdbm"
RDEPEND=${DEPEND}

S=${WORKDIR}/Sjeng-Free-${PV}

src_install () {
	default
	prepgamesdirs
}
