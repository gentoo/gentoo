# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/cloudflare/${PN}"
inherit golang-build golang-vcs-snapshot

SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Automated certificate management using a CFSSL CA"
HOMEPAGE="https://github.com/cloudflare/certmgr"
LICENSE="BSD-2"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	pushd src || die
	GOPATH="${S}" go install -v ${EGO_PN}/cmd/... || die
	popd || die
}

src_install() {
	dobin bin/*
	pushd src/${EGO_PN} || die
	dodoc README.md
	popd || die
}
