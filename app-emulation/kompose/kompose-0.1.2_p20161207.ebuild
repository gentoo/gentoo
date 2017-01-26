# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/kubernetes-incubator/kompose/..."
EGIT_COMMIT="04a3131834cddfb1af42b63b21641fbbf84a4a9d"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Tool to move from docker-compose to Kubernetes"
HOMEPAGE="https://github.com/kubernetes-incubator/kompose"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0/${PVR}"
IUSE="hardened"

src_prepare() {
	default
	sed -i -e "s/HEAD/${EGIT_COMMIT:0:7}/" src/${EGO_PN%/*}/version/version.go || die
}

src_compile() {
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')"
	GOPATH="${S}" go build -o bin/kompose src/${EGO_PN%/*}/main.go || die
}

src_install() {
	dobin bin/*
	dodoc -r src/${EGO_PN%/*}/{docs,{README,RELEASE,ROADMAP,CHANGELOG,CONTRIBUTING}.md}
}
