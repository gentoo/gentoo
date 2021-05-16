# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user systemd

DESCRIPTION="Dashboard Accelerator for Prometheus"
HOMEPAGE="https://github.com/Comcast/trickster"
VENDOR_URI="https://dev.gentoo.org/~williamh/dist/${P}-vendor.tar.gz"
SRC_URI="https://github.com/Comcast/trickster/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-lang/go:="

RESTRICT="strip"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	mv ../vendor .
}

src_compile() {
	set -- env GOCACHE="${T}"/go-cache go build -a -mod vendor -v
	echo $@
	"$@" || die "build failed"
}

src_install() {
	dobin ${PN}
dodoc -r conf docs/*
	systemd_dounit conf/trickster.service
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	insinto /etc/trickster
	doins "${FILESDIR}"/${PN}.conf
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
