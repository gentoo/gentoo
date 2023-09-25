# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module systemd
COMMIT=6b7e6cb1a

DESCRIPTION="Monitoring, processing and alerting on time series data"
HOMEPAGE="https://www.influxdata.com"
SRC_URI="https://github.com/influxdata/chronograf/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz
	https://dev.gentoo.org/~williamh/dist/${P}-gen.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="acct-group/chronograf
	acct-user/chronograf"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	default
	mv ../canned/bin_gen.go canned || die
	mv ../dist/dist_gen.go dist || die
	mv ../protoboards/bin_gen.go protoboards || die
	mv ../server/swagger_gen.go server || die
}

src_compile() {
	local go_ldflags
	go_ldflags="
		-X main.commit=${COMMIT}
		-X main.version=${PV}"
	go build \
		-o chronograf \
		-ldflags "${go_ldflags}" \
		./cmd/chronograf/main.go || die "could not compile chronograf"
	go build \
		-o chronoctl \
		-ldflags "${go_ldflags}" \
		./cmd/chronoctl || die "could not compile chronoctl"
}

src_install() {
	dobin chronograf chronoctl
	dodoc CHANGELOG.md
	insinto /etc/logrotate.d
	newins etc/scripts/logrotate chronograf
	systemd_dounit etc/scripts/chronograf.service
	insinto /usr/share/chronograf/canned
	doins canned/*.json
	keepdir /usr/share/chronograf/resources
	newconfd "${FILESDIR}"/chronograf.confd chronograf
	newinitd "${FILESDIR}"/chronograf.rc chronograf
	keepdir /var/log/chronograf
	fowners chronograf:chronograf /var/log/chronograf
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		einfo "In order to use chronograf, you will need to configure"
		einfo "the appropriate options in ${EROOT}/etc/conf.d/chronograf"
	fi
}
