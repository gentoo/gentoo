# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

DESCRIPTION="A modern IRC server written in Go"
HOMEPAGE="https://ergo.chat/ https://github.com/ergochat/ergo"
SRC_URI="https://github.com/ergochat/ergo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

# No test files are included in release tarballs
# We may even want to package irctest
RESTRICT="test"

BDEPEND=">=dev-lang/go-1.14"
RDEPEND="
	acct-user/oragono
	acct-group/oragono
"

DOCS=( README.md docs/MANUAL.md docs/USERGUIDE.md )

src_prepare() {
	default

	# Minor fiddling with paths
	sed -i \
		-e 's:/home/ergo/ergo:/usr/bin/ergo:' \
		-e 's:/home/ergo:/var/lib/ergo:' \
		-e 's:/var/lib/ergo/ircd.yaml:/etc/ergo/ircd.yaml:' \
		-e 's:User=ergo:User=oragono:' \
		distrib/systemd/ergo.service || die
}

src_compile() {
	go build -mod=vendor . || die
}

src_install() {
	einstalldocs

	dobin ergo

	insinto /etc/ergo
	doins default.yaml

	newinitd "${FILESDIR}"/ergo.initd ergo
	newconfd "${FILESDIR}"/ergo.confd ergo

	keepdir /var/lib/ergo
	fowners oragono:oragono /var/lib/ergo

	insinto /var/lib/ergo
	doins -r languages/

	systemd_dounit distrib/systemd/ergo.service
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog "Please copy the example config in ${EROOT}/etc/ergo:"
		elog "e.g. cp ${EROOT}/etc/ergo/default.yaml ${EROOT}/etc/ergo/ircd.yaml"
	fi
}
