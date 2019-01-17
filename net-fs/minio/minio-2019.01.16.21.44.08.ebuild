# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user golang-build golang-vcs-snapshot eapi7-ver

EGO_PN="github.com/minio/minio"
MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}
EGIT_COMMIT="ce419c98352324caa4c79b159a9f840ca714c3d5"
ARCHIVE_URI="https://${EGO_PN}/archive/RELEASE.${MY_PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~amd64-linux"

DESCRIPTION="An Amazon S3 compatible object storage server"
HOMEPAGE="https://github.com/minio/minio"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_prepare() {
	default
	sed -i -e "s/time.Now().UTC().Format(time.RFC3339)/\"${MY_PV}\"/"\
		-e "s/-s //"\
		-e "/time/d"\
		-e "s/+ commitID()/+ \"${EGIT_COMMIT}\"/"\
		src/${EGO_PN}/buildscripts/gen-ldflags.go || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	MINIO_RELEASE="${MY_PV}"
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
