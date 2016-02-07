# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/syncthing/syncthing"
EGIT_COMMIT=v${PV}

inherit golang-vcs-snapshot

DESCRIPTION="Syncthing is an open, trustworthy and decentralized cloud storage system"
HOMEPAGE="http://syncthing.net"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"
	cd src/${EGO_PN}
	go run build.go || die "build failed"
}

#go test: -race is only supported on amd64 platforms
#src_test() {
#	cd src/${EGO_PN}
#	go run build.go test || die "test failed"
#}

src_install() {
	cd src/${EGO_PN}
	dobin bin/*
	dodoc README.md AUTHORS  CONTRIBUTING.md
}
