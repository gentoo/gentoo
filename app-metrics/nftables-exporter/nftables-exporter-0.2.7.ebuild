# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

# make sure these are updated based on the Makefile in every bump.
GITVERSION=tags/v0.2.7-0-ga173315
SHA=a1733152

DESCRIPTION="prometheus exporter for nftables metrics"
HOMEPAGE="https://github.com/metal-stack/nftables-exporter"
SRC_URI="https://github.com/metal-stack/nftables-exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="net-firewall/nftables"

src_prepare() {
	default
	sed -i -e '/strip bin\//d' Makefile
}

src_compile() {
	emake \
		GONAME=${PN} \
		GITVERSION=${GITVERSION} \
		SHA=${SHA} \
		VERSION=v${PV} \
		all
}

src_install() {
dobin bin/${PN}
insinto etc
doins nftables_exporter.yaml
systemd_dounit systemd/nftables-exporter.service
newinitd "${FILESDIR}"/${PN}.initd ${PN}
keepdir /var/log/${PN}
}
