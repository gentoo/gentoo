# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple podcast aggregator, designed for cron"
HOMEPAGE="http://podracer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	app-shells/bash
	net-misc/curl"

src_unpack() {
	default

	# Bug 619956. Change directories first to ensure that
	# "unpack" outputs to ${S} and not to ${WORKDIR}.
	cd "${S}" || die
	unpack "${S}"/podracer.1.gz
}

src_prepare() {
	default
	sed -e "s:sample=/usr/share/doc/\$progname/sample.subscriptions:sample=/usr/share/doc/${PF}/sample.subscriptions:" \
		-i podracer || die
}

src_install() {
	dobin podracer

	dodoc CREDITS README ChangeLog TODO sample.subscriptions
	docompress -x /usr/share/doc/${PF}/sample.subscriptions
	doman podracer.1

	insinto /etc
	doins podracer.conf
}
