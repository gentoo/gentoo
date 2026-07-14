# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit go-module

DESCRIPTION="Tool like sed, awk, cut, join, and sort for name-indexed data (CSV, JSON, ..)"
HOMEPAGE="https://johnkerl.org/miller/doc/index.html"
# upstream's "packager tarball" doesn't include the docs directory, so use the
# original source
SRC_URI="https://github.com/johnkerl/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

BDEPEND="
	>=dev-lang/go-1.25.0
"

src_compile() {
	ego build github.com/johnkerl/miller/v6/cmd/mlr
}

src_test() {
	ego test github.com/johnkerl/miller/v6/pkg/...
	ego test -v regression_test.go
}

src_install() {
	dobin mlr

	einstalldocs

	doman man/mlr.1
}
