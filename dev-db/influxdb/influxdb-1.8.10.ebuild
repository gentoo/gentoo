# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd
GIT_COMMIT=688e697c51fd5353725da078555adbeff0363d01
GIT_BRANCH=1.8

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://www.influxdata.com"

SRC_URI="https://github.com/influxdata/influxdb/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/Dwosky/packages/raw/main/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 EPL-2.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="man"

BDEPEND="man? (
	app-text/asciidoc
	app-text/xmlto
)"
COMMON_DEPEND="
	acct-group/influxdb
	acct-user/influxdb"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_compile() {
	GOBIN="${S}/bin" \
		go install \
		-ldflags="-X main.version=${PV}
			-X main.branch=${GIT_BRANCH}
			-X main.commit=${GIT_COMMIT}" \
		./... || die "compile failed"
	use man && emake -C man build
}

src_install() {
	dobin bin/influx*
	dodoc *.md
	use man && doman man/*.1
	insinto /etc/influxdb
	newins etc/config.sample.toml influxdb.conf
	insinto /etc/logrotate.d
	newins scripts/logrotate influxdb
	systemd_dounit scripts/influxdb.service

	newconfd "${FILESDIR}"/influxdb.confd influxdb
	newinitd "${FILESDIR}"/influxdb.initd influxdb
	keepdir /var/log/influxdb
	fowners influxdb:influxdb /var/log/influxdb
}

src_test() {
	go test ./tests || die
}
