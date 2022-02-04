# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit golang-build golang-vcs-snapshot systemd
EGO_PN=github.com/influxdata/kapacitor

DESCRIPTION="Monitoring, processing and alerting on time series data"
HOMEPAGE="https://www.influxdata.com"
SRC_URI="https://github.com/influxdata/kapacitor/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="acct-group/kapacitor
	acct-user/kapacitor"
	DEPEND="${COMMON_DEPEND}"
	RDEPEND="${COMMON_DEPEND}"

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
