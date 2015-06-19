# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/podget/podget-0.6.ebuild,v 1.2 2011/02/15 21:53:36 darkside Exp $

EAPI=4

DESCRIPTION="A simple podcast aggregator written in bash"
HOMEPAGE="http://podget.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	# There is a Makefile that we don't use
	:
}

src_install() {
	dobin podget
	doman DOC/podget.7
	dodoc -r Changelog README SCRIPTS/
}
