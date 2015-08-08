# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# EAPI=4 is not allowed unless somone re-works the sample.subscriptions logic
# (because it gets compressed with EAPI=4). To test this, start podracer without
# a subscriptions file
EAPI=3

DESCRIPTION="A simple podcast aggregator, designed for cron"
HOMEPAGE="http://podracer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash
	net-misc/curl"

src_install() {
	dobin podracer
	sed -i -e "s:sample=/usr/share/doc/\$progname/sample.subscriptions:sample=/usr/share/doc/${PF}/sample.subscriptions:" "${D}"/usr/bin/podracer || die
	dodoc CREDITS README ChangeLog TODO
	doman podracer.1.gz
	insinto /usr/share/doc/${PF}
	doins sample.subscriptions
	insinto /etc/
	doins podracer.conf
}
