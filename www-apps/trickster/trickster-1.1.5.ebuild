# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Dashboard Accelerator for Prometheus"
HOMEPAGE="https://github.com/tricksterproxy/trickster"
VENDOR_URI="https://dev.gentoo.org/~williamh/dist/${P}-vendor.tar.xz"
SRC_URI="https://github.com/tricksterproxy/trickster/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="
	acct-group/trickster
	acct-user/trickster"
	DEPEND="${COMMON_DEPEND}"
	RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	default
	mv ../vendor .
}

src_compile() {
	set -- go build -mod vendor ./cmd/trickster
	echo $@
	"$@" || die "build failed"
}

src_install() {
	dobin ${PN}
dodoc -r conf docs/*
	systemd_dounit conf/trickster.service
	insinto /etc/trickster
	doins "${FILESDIR}"/${PN}.conf
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
