# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
COMMIT=5efa06acfb3bb4e65d2711cf5255970948e047cf
inherit go-module

DESCRIPTION="Manipulation tool for OCI images"
HOMEPAGE="https://github.com/opencontainers/umoci"
SRC_URI="https://github.com/opencontainers/umoci/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-go/go-md2man"

RESTRICT+=" test "

src_compile() {
	go build -buildmode=pie -mod=vendor \
		-ldflags "-w -X main.gitCommit=${COMMIT} -X main.version=${PV}" \
		-o "bin/${PN}" ./cmd/${PN} || die
	cd doc/man
	for f in *.1.md; do
		go-md2man -in ${f} -out ${f%%.md} || die
	done
}

src_install() {
	dobin bin/${PN}
	doman doc/man/*.1
	dodoc CHANGELOG.md
	einstalldocs
}
