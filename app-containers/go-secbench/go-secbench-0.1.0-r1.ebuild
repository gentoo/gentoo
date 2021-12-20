# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/qnib/go-secbench"
inherit golang-build golang-vcs-snapshot

DESCRIPTION="run and evaluate the docker security benchmark"
HOMEPAGE="https://github.com/qnib/go-secbench"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

DEPEND="dev-lang/go"
RDEPEND="app-emulation/docker"

src_compile() {
	GOPATH="${S}" go build -o bin/go-secbench src/${EGO_PN}/cmd/main.go || die
}

src_install() {
	dobin bin/${PN}
dodoc "src/${EGO_PN}/README.md"
}
