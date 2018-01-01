# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/minio/minio"
VERSION="2017-11-22T19-55-46Z"
EGIT_COMMIT="d1a6c32d800f1d5b703baad1f8aeede6cf2cdf48"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="An Amazon S3 compatible object storage server"
HOMEPAGE="https://github.com/minio/minio"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_prepare() {
	default
	sed -i -e "s/time.Now().UTC().Format(time.RFC3339)/\"${VERSION}\"/"\
		-e "s/-s //"\
		-e "/time/d"\
		-e "s/+ commitID()/+ \"${EGIT_COMMIT}\"/"\
		src/${EGO_PN}/buildscripts/gen-ldflags.go || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	MINIO_RELEASE="${VERSION}"
	go run buildscripts/gen-ldflags.go
	GOPATH="${S}" go build --ldflags "$(go run buildscripts/gen-ldflags.go)" -o ${PN} || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dodoc -r README.md CONTRIBUTING.md MAINTAINERS.md docs
	dobin minio
	popd  || die
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
}
