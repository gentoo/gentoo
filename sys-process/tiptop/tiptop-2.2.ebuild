# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/tiptop/tiptop-2.2.ebuild,v 1.3 2015/04/01 18:24:29 nativemad Exp $

EAPI=5

DESCRIPTION="top for performance counters"
HOMEPAGE="http://tiptop.gforge.inria.fr/"
SRC_URI="http://${PN}.gforge.inria.fr/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-libs/ncurses
	dev-libs/libxml2"
DEPEND="${RDEPEND}"
