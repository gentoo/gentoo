# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

GO_PN=github.com/coreos/${PN}
EGIT_COMMIT="25e2c63be8e8ab405014a78879e0992ae5ff55e8"

DESCRIPTION="Go client library for etcd"
HOMEPAGE="https://${GO_PN}"
SRC_URI="https://${GO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/go-1.4"
RDEPEND=""

S=${WORKDIR}

src_unpack() {
	default_src_unpack
	mkdir -p src/${GO_PN%/*} || die
	mv ${PN}-${EGIT_COMMIT} src/${GO_PN} || die
}

src_compile() {
	# Create a filtered GOROOT tree out of symlinks,
	# excluding go-etcd, for bug #503324.
	cp -sR /usr/lib/go goroot || die
	rm -rf goroot/src/${GO_PN} || die
	rm -rf goroot/pkg/linux_${ARCH}/${GO_PN} || die
	GOROOT=${WORKDIR}/goroot GOPATH=${WORKDIR} \
		go install -x ${GO_PN}/etcd || die
}

src_install() {
	insopts -m0644 -p # preserve timestamps for bug 551486
	insinto /usr/lib/go
	doins -r pkg
	insinto /usr/lib/go/src
	egit_clean
	doins -r src/*
}
