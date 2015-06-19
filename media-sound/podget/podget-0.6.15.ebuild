# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/podget/podget-0.6.15.ebuild,v 1.2 2014/01/20 07:58:12 heroxbd Exp $

EAPI=5

MY_P="${PN}-${PV}"

DESCRIPTION="A simple podcast aggregator written in bash"
HOMEPAGE="http://podget.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/grep
	sys-apps/sed
	app-text/tofrodos
	net-misc/wget"

src_compile() {
		# There is a Makefile that we don't use
		:
}

src_install() {
		dobin ${PN}
		doman DOC/${PN}.7
		dodoc -r Changelog README SCRIPTS/
}
