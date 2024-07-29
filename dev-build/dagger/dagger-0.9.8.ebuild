# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="ci/cd as code that runs anywhere"
HOMEPAGE="http://dagger.io"
SRC_URI="https://github.com/dagger/dagger/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
src_compile() {
	ego build -o bin/dagger ./cmd/dagger
}

src_install() {
dobin bin/*
}
