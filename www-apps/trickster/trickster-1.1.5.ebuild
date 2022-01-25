# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Dashboard Accelerator for Prometheus"
HOMEPAGE="https://github.com/tricksterproxy/trickster"
SRC_URI="https://github.com/tricksterproxy/trickster/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="
	acct-group/trickster
	acct-user/trickster"
	DEPEND="${COMMON_DEPEND}"
	RDEPEND="${COMMON_DEPEND}"

	RESTRICT="test"

src_compile() {
	set -- go build -mod vendor ./cmd/trickster
	echo $@
	"$@" || die "build failed"
}

src_install() {
	dobin ${PN}
dodoc -r docs/*
	systemd_dounit deploy/systemd/trickster.service
	insinto /etc/trickster
	doins "${FILESDIR}"/${PN}.conf
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
