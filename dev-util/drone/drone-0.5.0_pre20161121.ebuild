# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/drone/drone/..."
EGIT_COMMIT="1dbf78235606ecd715f84f004e6459225c101031"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A Continuous Delivery platform built on Docker, written in Go"
HOMEPAGE="https://github.com/drone/drone"
SRC_URI="${ARCHIVE_URI}
	https://github.com/drone/mq/archive/866849da524e700ba7af26f7d6fa4d0d40541115.tar.gz -> drone-mq-866849da524e700ba7af26f7d6fa4d0d40541115.tar.gz
	https://github.com/tidwall/redlog/archive/54086c8553cd23aba652513a87d2b085ea961541.tar.gz -> tidwall-redlog-54086c8553cd23aba652513a87d2b085ea961541.tar.gz
	https://github.com/golang/crypto/archive/ede567c8e044a5913dad1d1af3696d9da953104c.tar.gz -> golang-crypto-ede567c8e044a5913dad1d1af3696d9da953104c.tar.gz"
LICENSE="Apache-2.0"
SLOT="0/${PVR}"
IUSE=""

DEPEND="dev-go/go-bindata
	dev-util/drone-ui:="

_golang-include-src() {
	local VENDORPN=$1 TARBALL=$2
	mkdir -p "${WORKDIR}/${P}/src/${VENDORPN}" || die
	tar -C "${WORKDIR}/${P}/src/${VENDORPN}" -x --strip-components 1\
		-f "${DISTDIR}"/${TARBALL} || die
}

src_unpack() {
	golang-vcs-snapshot_src_unpack
	_golang-include-src github.com/drone/mq drone-mq-866849da524e700ba7af26f7d6fa4d0d40541115.tar.gz
	_golang-include-src github.com/tidwall/redlog tidwall-redlog-54086c8553cd23aba652513a87d2b085ea961541.tar.gz
	_golang-include-src golang.org/x/crypto golang-crypto-ede567c8e044a5913dad1d1af3696d9da953104c.tar.gz
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
