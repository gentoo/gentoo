# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/promu"
EGIT_COMMIT="264dc36af9ea3103255063497636bd5713e3e9c1"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus Utility Tool"
HOMEPAGE="https://github.com/prometheus/promu"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.11"

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${EGIT_COMMIT}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" emake build
	popd || die
}

src_install() {
	dobin bin/*
	dodoc -r src/${EGO_PN}/{doc,{README,CONTRIBUTING}.md}
}
