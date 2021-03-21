# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN=github.com/influxdata/telegraf

inherit systemd user

MY_PV="${PV/_rc/-rc.}"
COMMIT=0ea49ea9
DESCRIPTION="The plugin-driven server agent for collecting & reporting metrics."
HOMEPAGE="https://github.com/influxdata/telegraf"
SRC_URI="https://github.com/influxdata/telegraf/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~williamh/dist/${P}-vendor.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip"

DEPEND="dev-lang/go"

pkg_setup() {
	enewgroup telegraf
	enewuser telegraf -1 -1 -1 telegraf
}

src_prepare() {
	default
	mv ../vendor .
}

src_compile() {
	echo module ${EGO_PN} > go.mod
	set -- env GO111MODULE=on go build -mod vendor -v -x -o telegraf \
		-ldflags="-X main.commit=${COMMIT} -X main.version=${PV}" \
		cmd/telegraf/telegraf.go
	echo "$@"
	"$@" || die
}

src_install() {
	dobin telegraf
	insinto /etc/telegraf
	doins etc/telegraf.conf
	keepdir /etc/telegraf/telegraf.d

	insinto /etc/logrotate.d
	doins etc/logrotate.d/telegraf

	systemd_dounit scripts/telegraf.service
	newconfd "${FILESDIR}"/telegraf.confd telegraf
	newinitd "${FILESDIR}"/telegraf.rc telegraf

	dodoc -r docs/*

	keepdir /var/log/telegraf
	fowners telegraf:telegraf /var/log/telegraf
}
