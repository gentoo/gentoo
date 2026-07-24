# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo go-module

GOPROJECT=github.com/opencontainers/umoci
COMMIT=1c44d6f2f9e4b50f5d2a99463f540acf9915dd47

DESCRIPTION="Manipulation tool for OCI images"
HOMEPAGE="https://github.com/opencontainers/umoci"
SRC_URI="https://github.com/opencontainers/umoci/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

BDEPEND="dev-go/go-md2man"

src_compile() {
	ego build -buildmode=pie -mod=vendor \
		-ldflags "-w -X ${GOPROJECT}.gitCommit=${COMMIT}" \
		-o "bin/${PN}" ./cmd/${PN}

	cd doc/man || die
	for f in *.1.md; do
		edo go-md2man -in ${f} -out ${f%%.md}
	done
}

src_install() {
	dobin bin/${PN}
	doman doc/man/*.1
	local DOCS=( CHANGELOG.md README.md )
	einstalldocs
}
