# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/mholt/caddy 6aba4a311ac1f12c762d6b54a77aedec7d42f615" )

EGO_PN="github.com/${PN}/${PN}"

inherit golang-build golang-vcs-snapshot

EGIT_COMMIT="v${PV}"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A DNS server that chains middleware"
HOMEPAGE="https://github.com/coredns/coredns"

SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go build || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN}
	dobin ${PN}
	dodoc README.md
	popd || die
}
