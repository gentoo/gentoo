# Copyright 2018 Sony Interactive Entertainment Inc.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/kubernetes-sigs/cri-tools"
MY_PV="v${PV/_beta/-beta.}"
ARCHIVE_URI="https://${EGO_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="CLI and validation tools for Kubelet Container Runtime (CRI)"
HOMEPAGE="https://github.com/kubernetes-sigs/cri-tools"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	GOPATH="${S}" go test -c -v -ldflags="-X ${EGO_PN}/pkg/version.Version=${MY_PV}" -o bin/critest ${EGO_PN}/cmd/critest || die
	GOPATH="${S}" go build -v -ldflags="-X ${EGO_PN}/pkg/version.Version=${MY_PV}" -o bin/crictl ${EGO_PN}/cmd/crictl || die
}

src_install() {
	dobin bin/*
	dodoc -r src/${EGO_PN}/{docs,{README,RELEASE,CHANGELOG,CONTRIBUTING}.md}
}
