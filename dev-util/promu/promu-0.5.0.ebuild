# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/promu"
EGIT_COMMIT="642a960b363a409efff7621dbf5b183d58670ec2"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64"

DESCRIPTION="Prometheus Utility Tool"
HOMEPAGE="https://github.com/prometheus/promu"
LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
IUSE=""
RESTRICT="test"

DEPEND=">=dev-lang/go-1.12"

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${EGIT_COMMIT}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	GO111MODULE=off GOCACHE="${T}/go-cache" GOPATH="${S}" go install -v github.com/prometheus/promu || die
	popd || die
}

src_install() {
	dobin bin/*
	dodoc -r src/${EGO_PN}/{doc,{README,CONTRIBUTING}.md}
}
