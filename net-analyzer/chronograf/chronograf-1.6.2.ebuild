# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/influxdata/chronograf

inherit golang-build golang-vcs-snapshot systemd user

DESCRIPTION="Monitoring, processing and alerting on time series data"
HOMEPAGE="https://www.influxdata.com"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~williamh/dist/${PN}-gen-${PV}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

pkg_setup() {
	enewgroup chronograf
	enewuser chronograf -1 -1 /var/lib/chronograf chronograf
}

src_unpack() {
	local f
	golang-vcs-snapshot_src_unpack
	pushd "${S}/src/${EGO_PN}" > /dev/null || die
	for f in ${A}; do
		case $f in
			${PN}-gen-*.tar.*)
				unpack ${f}
				;;
		esac
	done
}

src_compile() {
	pushd "src/${EGO_PN}" > /dev/null || die
	set -- env GOPATH="${S}" go build -o chronograf cmd/chronograf/main.go
	echo "$@"
	"$@" || die "building chronograf failed"
	set -- env GOPATH="${S}" go build -o chronoctl cmd/chronoctl/main.go
	echo "$@"
	"$@" ||	die "building chronoctl failed"
	popd > /dev/null || die
}

src_install() {
	pushd "src/${EGO_PN}" > /dev/null || die
dobin chronograf chronoctl
	dodoc CHANGELOG.md
	insinto /etc/logrotate.d
	newins etc/scripts/logrotate chronograf
	systemd_dounit etc/scripts/chronograf.service
	insinto /usr/share/chronograf/canned
doins canned/*.json
keepdir /usr/share/chronograf/resources
	keepdir /var/log/chronograf
	fowners chronograf:chronograf /var/log/chronograf
	newconfd "${FILESDIR}"/chronograf.confd chronograf
	newinitd "${FILESDIR}"/chronograf.rc chronograf
	popd > /dev/null || die
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		einfo "In order to use chronograf, you will need to configure"
		einfo "the appropriate options in ${EROOT}etc/conf.d/chronograf"
	fi
}
