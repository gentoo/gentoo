# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Prometheus exporter for LVM metrics"
HOMEPAGE="https://github.com/hansmi/prometheus-lvm-exporter"
SRC_URI="
	https://github.com/hansmi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~arthurzam/distfiles/app-metrics/${PN}/${P}-deps.tar.xz
"

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# lvm is explicitly not included here; this could be installed before it safely.
# RDEPEND=""

src_prepare() {
	default
	sed -i -e '/kingpin.Flag.*\<command\>.*/s,/usr/sbin/lvm,/sbin/lvm,g' "${S}"/main.go || die
}

src_compile() {
	default
	ego build .
}

src_test() {
	ego test .
}

src_install() {
	default
	dobin ${PN}
	dodoc README.md

	systemd_dounit contrib/systemd/${PN}.service
	insinto /etc/default
	newins contrib/systemd/${PN}.default ${PN}

	# TODO: more secure config would be a dedicated user AND a sudo command, so
	# the daemon can run 'sudo lvm ...'.
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
