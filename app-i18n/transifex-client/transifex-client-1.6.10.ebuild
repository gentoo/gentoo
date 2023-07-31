# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="The Transifex command-line client"
HOMEPAGE="https://github.com/transifex/cli"

SRC_URI="https://github.com/transifex/cli/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://gitlab.com/api/v4/projects/35204985/packages/generic/${PN}/${PV}/${P}-deps.tar.bz"
S="${WORKDIR}"/cli-${PV}

LICENSE="Apache-2.0 BSD BSD-2 ISC LGPL-3 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

src_compile() {
	emake GOFLAGS="${GOFLAGS} -ldflags=-X="github.com/transifex/cli/internal/txlib.Version=${PV}
}

src_test() {
	# Skip tests depending on a network connection. Bug #831772
	rm internal/txlib/update_test.go || die
	go test ./... || die
}

src_install() {
	dobin bin/tx
	dodoc README.md
}
