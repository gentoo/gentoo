# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/promu"
EGIT_COMMIT="5a3cc08574c63bb853a21c570d719a0fb548dae0"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus Utility Tool"
HOMEPAGE="https://github.com/prometheus/promu"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

src_compile() {
	LDFLAGS="-X github.com/prometheus/vendor/github.com/prometheus/common/version.Version=$(cat src/${EGO_PN}/VERSION)
	-X github.com/prometheus/vendor/github.com/prometheus/common/version.Revision=${EGIT_COMMIT:0:7}
	-extldflags \"-static\""
	GOPATH="${S}" go build -ldflags "${LDFLAGS}" -o bin/promu src/${EGO_PN}/main.go || die
}

src_install() {
	dobin bin/*
	dodoc -r src/${EGO_PN}/{doc,{README,CONTRIBUTING}.md}
}
