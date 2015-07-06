# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/godep/godep-0_p20150520-r1.ebuild,v 1.1 2015/07/06 21:33:26 williamh Exp $

EAPI=5

KEYWORDS="~amd64"
DESCRIPTION="dependency tool for go"
GO_PN=github.com/tools/${PN}
HOMEPAGE="https://${GO_PN}"
EGIT_COMMIT="98f5c2e8906df47a9eaafebbcd406adde2c8d0a7"
SRC_URI="https://${GO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
https://github.com/kr/fs/archive/2788f0dbd16903de03cb8186e5c7d97b69ad387b.tar.gz -> go-fs-2788f0dbd16903de03cb8186e5c7d97b69ad387b.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND=">=dev-lang/go-1.4:="
RDEPEND=""
S="${WORKDIR}/src/${GO_PN}"
STRIP_MASK="*.a"

src_unpack() {
	default
	mkdir -p src/${GO_PN%/*} || die
	mv ${PN}-${EGIT_COMMIT} src/${GO_PN} || die
	mkdir -p src/github.com/kr || die
	mv fs-2788f0dbd16903de03cb8186e5c7d97b69ad387b  src/github.com/kr/fs || die
}

src_prepare() {
	# disable broken tests
	sed -e 's:TestSave(:_\0:' -i save_test.go || die
	sed -e 's:TestUpdate(:_\0:' -i update_test.go || die
}

src_compile() {
	GOPATH=${WORKDIR} go install -v -x -work ${GO_PN}/... || die
}

src_test() {
	GOPATH=${WORKDIR} \
		go test -x -v ${GO_PN}/... || die $?
}

src_install() {
	dobin "${WORKDIR}"/bin/*
}
