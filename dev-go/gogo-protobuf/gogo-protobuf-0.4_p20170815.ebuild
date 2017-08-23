# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/gogo/protobuf"
EGIT_COMMIT="fcdc5011193ff531a548e9b0301828d5a5b97fd8"

inherit golang-build golang-vcs-snapshot

ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Protocol Buffers for Go with Gadgets"
HOMEPAGE="https://github.com/gogo/protobuf"
SRC_URI="${ARCHIVE_URI}"
LICENSE="BSD"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	pushd src || die
	GOPATH="${WORKDIR}/${P}"\
		go install ${EGO_PN}/protoc-gen-gogo || die
	GOPATH="${WORKDIR}/${P}"\
		go install ${EGO_PN}/protoc-gen-gofast || die
	GOPATH="${WORKDIR}/${P}"\
		go install ${EGO_PN}/protoc-gen-gogofast || die
	GOPATH="${WORKDIR}/${P}"\
		go install ${EGO_PN}/protoc-gen-gogoslick || die
		GOPATH="${WORKDIR}/${P}"\
		go install ${EGO_PN}/protoc-gen-gogofaster || die
	popd || die
}

src_install() {
	dobin bin/protoc-gen-{gogo,gofast,gogofast,gogofaster}
	dodoc src/${EGO_PN}/README
}
