# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/drone/drone/..."
EGIT_COMMIT="4c036b7838f32a3615a8f73c4ddabb7001b0b4d1"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A Continuous Delivery platform built on Docker, written in Go"
HOMEPAGE="https://github.com/drone/drone"
SRC_URI="${ARCHIVE_URI}
	https://github.com/drone/mq/archive/280af2a3b9c7d9ce90d625150dfff972c6c190b8.tar.gz -> drone-mq-280af2a3b9c7d9ce90d625150dfff972c6c190b8.tar.gz
	https://github.com/tidwall/redlog/archive/550629ebbfa9925a73f69cce7cdd2e8dae52c713.tar.gz -> tidwall-redlog-550629ebbfa9925a73f69cce7cdd2e8dae52c713.tar.gz
	https://github.com/golang/crypto/archive/453249f01cfeb54c3d549ddb75ff152ca243f9d8.tar.gz -> golang-crypto-453249f01cfeb54c3d549ddb75ff152ca243f9d8.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-go/go-bindata
	dev-go/go-bindata-assetfs:=
	dev-util/drone-ui:="

_golang-include-src() {
	local VENDORPN=$1 TARBALL=$2
	mkdir -p "${WORKDIR}/${P}/src/${VENDORPN}" || die
	tar -C "${WORKDIR}/${P}/src/${VENDORPN}" -x --strip-components 1\
		-f "${DISTDIR}"/${TARBALL} || die
}

src_unpack() {
	golang-vcs-snapshot_src_unpack
	_golang-include-src github.com/drone/mq drone-mq-*.tar.gz
	_golang-include-src github.com/tidwall/redlog tidwall-redlog-*.tar.gz
	_golang-include-src golang.org/x/crypto golang-crypto-*.tar.gz
}
src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)"	emake -C src/github.com/drone/drone gen || die
	pushd src || die
	DRONE_BUILD_NUMBER="${EGIT_COMMIT:0:7}" GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)"\
		go install -ldflags "-extldflags '-static' -X github.com/drone/drone/version.VersionDev=${EGIT_COMMIT:0:7}" github.com/drone/drone/drone || die
	popd || die
}

src_install() {
	dobin bin/*
}
