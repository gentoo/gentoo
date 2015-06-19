# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/xjobs/xjobs-20140125.ebuild,v 1.3 2015/04/19 09:43:09 ago Exp $

EAPI=5

DESCRIPTION="Reads commands line by line and executes them in parallel"
HOMEPAGE="http://www.maier-komor.de/${PN}.html"
SRC_URI="http://www.maier-komor.de/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-devel/flex"
RDEPEND=""
