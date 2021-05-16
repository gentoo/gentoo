# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

DESCRIPTION="A modern IRC server written in Go"
HOMEPAGE="https://oragono.io/ https://github.com/oragono/oragono"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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
		-e 's:/home/oragono/oragono:/usr/bin/oragono:' \
		-e 's:/home/oragono:/var/lib/oragono:' \
		-e 's:/var/lib/oragono/ircd.yaml:/etc/oragono/ircd.yaml:' \
		distrib/systemd/oragono.service || die
}

src_compile() {
	go build -mod=vendor . || die
}

src_install() {
	einstalldocs

	dobin oragono

	insinto /etc/oragono
	doins default.yaml

	newinitd "${FILESDIR}"/oragono.initd oragono
	newconfd "${FILESDIR}"/oragono.confd oragono

	keepdir /var/lib/oragono
	fowners oragono:oragono /var/lib/oragono

	insinto /var/lib/oragono
	doins -r languages/

	systemd_dounit distrib/systemd/oragono.service
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog "Please copy the example config in ${EROOT}/etc/oragono:"
		elog "e.g. cp ${EROOT}/etc/oragono/default.yaml ${EROOT}/etc/oragono/ircd.yaml"
	fi
}
