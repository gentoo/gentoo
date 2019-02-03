# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/influxdata/kapacitor

inherit golang-build golang-vcs-snapshot systemd user

DESCRIPTION="Monitoring, processing and alerting on time series data"
HOMEPAGE="https://www.influxdata.com"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

pkg_setup() {
	enewgroup kapacitor
	enewuser kapacitor -1 -1 /var/lib/kapacitor kapacitor
}

src_compile() {
	pushd "src/${EGO_PN}" > /dev/null || die
	set -- env GOPATH="${S}" go build -v -work -x ./...
	echo "$@"
	"$@" || die "compile failed"
	popd > /dev/null
}

src_install() {
	pushd "src/${EGO_PN}" > /dev/null || die
	set -- env GOPATH="${S}" go install -v -work -x ./...
	echo "$@"
	"$@" || die
	dobin "${S}"/bin/kapacitor{,d}
	insinto /etc/kapacitor
doins etc/kapacitor/kapacitor.conf
keepdir /etc/kapacitor/load
	insinto /etc/logrotate.d
	doins etc/logrotate.d/kapacitor
	systemd_dounit scripts/kapacitor.service
	keepdir /var/log/kapacitor
	fowners kapacitor:kapacitor /var/log/kapacitor
	newconfd "${FILESDIR}"/kapacitor.confd kapacitor
	newinitd "${FILESDIR}"/kapacitor.rc kapacitor
	popd > /dev/null || die
}
