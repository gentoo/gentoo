# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_SRC="github.com/rakyll/hey"
EGO_PN=${EGO_SRC}/...
EGIT_COMMIT="01803349acd49d756dafa2cb6ac5b5bfc141fc3b"

inherit golang-build golang-vcs-snapshot

DESCRIPTION="HTTP load generator, ApacheBench (ab) replacement, formerly known as rakyll/boom"
HOMEPAGE="https://github.com/rakyll/hey"
SRC_URI="https://${EGO_SRC}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"
IUSE=""
DEPEND=""
RDEPEND=""
S=${WORKDIR}/${P}/src/${EGO_SRC}

src_compile() {
	GOPATH="${WORKDIR}/${P}" GOBIN="${WORKDIR}/${P}/bin" GO111MODULE=on \
		go install -mod=vendor -v -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_install() {
	dobin "${WORKDIR}/${P}/bin"/*
	dodoc README.md
}
