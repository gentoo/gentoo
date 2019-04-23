# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/ncabatoff/process-exporter

inherit golang-build golang-vcs-snapshot systemd

DESCRIPTION="Process exporter for prometheus"
HOMEPAGE="https://github.com/ncabatoff/process-exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip"

src_compile() {
	pushd "src/${EGO_PN}" || die
	GOPATH="${S}" emake build
}

src_install() {
	pushd "src/${EGO_PN}" || die
	dobin ${PN}
dodoc *.md
	insinto /etc/${PN}
	doins packaging/conf/all.yaml
	systemd_dounit packaging/${PN}.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
