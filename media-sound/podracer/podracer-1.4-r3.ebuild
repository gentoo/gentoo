# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple podcast aggregator, designed for cron"
HOMEPAGE="https://podracer.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

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
