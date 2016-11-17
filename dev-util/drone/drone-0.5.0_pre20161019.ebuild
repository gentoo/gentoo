# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/drone/drone/..."
EGIT_COMMIT="0852424cfef6e518458f9de1ed0a04ba22d60171"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A Continuous Delivery platform built on Docker, written in Go"
HOMEPAGE="https://github.com/drone/drone"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0/${PVR}"
IUSE=""

DEPEND="dev-go/go-bindata
	dev-util/drone-ui:="

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)"	emake -C src/github.com/drone/drone gen || die
	pushd src || die
	DRONE_BUILD_NUMBER="${EGIT_COMMIT}" GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)"\
		go install -ldflags "-extldflags '-static' -X github.com/drone/drone/version.VersionDev=${EGIT_COMMIT}" github.com/drone/drone/drone || die
	popd || die
}

src_install() {
	dobin bin/*
}
