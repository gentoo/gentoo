# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/kubernetes-incubator/kompose/..."
EGIT_COMMIT="v0.3.0"
COMPOSE_COMMIT="135165b"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Tool to move from docker-compose to Kubernetes"
HOMEPAGE="https://github.com/kubernetes-incubator/kompose"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0/${PVR}"
IUSE="hardened"

RESTRICT="test"

src_compile() {
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')"
	GOPATH="${S}" go build -ldflags="-X github.com/kubernetes-incubator/kompose/cmd.GITCOMMIT=${COMPOSE_COMMIT}" -o bin/kompose src/${EGO_PN%/*}/main.go || die
}

src_install() {
	dobin bin/*
	dodoc -r src/${EGO_PN%/*}/{docs,{README,RELEASE,ROADMAP,CHANGELOG,CONTRIBUTING}.md}
}
