# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="'go test' runner with output optimized for humans"
HOMEPAGE="https://github.com/gotestyourself/gotestsum"
SRC_URI="https://github.com/gotestyourself/gotestsum/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~xen0n/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~loong"

src_compile() {
	ego build
}

src_test() {
	# the program's E2E test does not want verbose output from Go
	GOFLAGS="${GOFLAGS//-x}" ego test ./...
}

src_install() {
	dobin gotestsum
	local DOCS=( README.md )
	einstalldocs
}
