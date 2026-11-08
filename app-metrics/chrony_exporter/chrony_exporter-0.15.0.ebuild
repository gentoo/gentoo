# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Chrony NTP exporter for Prometheus"
HOMEPAGE="https://github.com/SuperQ/chrony_exporter"

SRC_URI="https://github.com/SuperQ/chrony_exporter/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/gentoo-golang-dist/chrony_exporter/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/chrony_exporter
		acct-user/chrony_exporter"

BDEPEND="
	>=dev-lang/go-1.27.0
	dev-util/promu
"

# Applies these changes:
# yq '.go.cgo=true | .build.static=false |  .build.binaries[0].name="chrony_exporter"' .promu.yml
PATCHES=( "${FILESDIR}/0.15.0-promu-config.patch" )

src_prepare() {
	default

	# No need to enable the race detector for tests (#935442)
	sed -i -e '/test-flags := -race/d' Makefile.common || die
}

src_compile() {
	promu build -v || die
}

src_install() {
	dobin ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/sysconfig
	doins "${FILESDIR}"/${PN}.sysconfig # See https://wiki.gentoo.org/wiki/Project:Systemd/conf.d_files
	systemd_dounit "${FILESDIR}"/chrony_exporter-0.15.0.{service,socket}
}
