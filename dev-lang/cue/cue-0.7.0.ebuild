# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="open-source data validation language and inference engine"
HOMEPAGE="https://cuelang.org"
SRC_URI="https://github.com/cue-lang/cue/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -o bin/cue ./cmd/cue
}

src_install() {
	dobin bin/*
	einstalldocs
dodoc -r doc
}
