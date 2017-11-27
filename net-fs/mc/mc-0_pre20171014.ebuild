# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/minio/mc"
VERSION="2017-10-14T00-51-16Z"
EGIT_COMMIT="785e14a725357b39e22b74483cd202e7effa6195"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Minio client provides alternatives for ls, cat on cloud storage and filesystems"
HOMEPAGE="https://github.com/minio/mc"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

RDEPEND="!!app-misc/mc"

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
	MC_RELEASE="${VERSION}"
	go run buildscripts/gen-ldflags.go
	GOPATH="${S}" go build --ldflags "$(go run buildscripts/gen-ldflags.go)" -o ${PN} || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dodoc -r README.md CONTRIBUTING.md docs
	dobin mc
	popd  || die
}
