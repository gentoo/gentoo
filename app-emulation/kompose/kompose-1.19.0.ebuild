# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/kubernetes/kompose"
EGIT_COMMIT="v${PV}"
GIT_COMMIT="f63a961ca7972cb243507755c69cd066aa792289"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Tool to move from docker-compose to Kubernetes"
HOMEPAGE="https://github.com/kubernetes/kompose https://kompose.io"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="hardened"

RESTRICT="test"

src_compile() {
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')"
	GOPATH="${S}" go build -v -ldflags="-X github.com/kubernetes/kompose/cmd.GITCOMMIT=${GIT_COMMIT}" -o bin/kompose src/${EGO_PN}/main.go || die
}

src_install() {
	dobin bin/*
	dodoc -r src/${EGO_PN}/{docs,{README,RELEASE,CHANGELOG,CONTRIBUTING}.md}
}
