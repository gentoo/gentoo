# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A simple podcast aggregator, designed for cron"
HOMEPAGE="http://podracer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash
	net-misc/curl"

src_unpack() {
	default

	# Bug 619956. Change directories first to ensure that "unpack" outputs
	# to ${S} and not to ${WORKDIR}.
	cd "${S}" || die
	unpack "${S}/podracer.1.gz"
}

src_install() {
	dobin podracer
	sed -i -e "s:sample=/usr/share/doc/\$progname/sample.subscriptions:sample=/usr/share/doc/${PF}/sample.subscriptions:" "${D}"/usr/bin/podracer || die
	dodoc CREDITS README ChangeLog TODO
	doman podracer.1
	docompress -x "/usr/share/doc/${PF}/sample.subscriptions"
	dodoc sample.subscriptions
	insinto /etc/
	doins podracer.conf
}
