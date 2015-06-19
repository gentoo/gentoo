# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/sflowtool/sflowtool-3.34.ebuild,v 1.4 2015/04/19 09:52:24 pacho Exp $

EAPI=5
inherit flag-o-matic

DESCRIPTION="sflowtool is a utility for collecting and processing sFlow data"
HOMEPAGE="http://www.inmon.com/technology/sflowTools.php"
SRC_URI="http://www.inmon.com/bin/${P}.tar.gz"

LICENSE="inmon-sflow"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

src_prepare() {
	append-cppflags -DSPOOFSOURCE
	use debug && append-cppflags -DDEBUG
}
