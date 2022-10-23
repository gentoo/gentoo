# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="command line interface for the Sourcegraph code search tool"
HOMEPAGE="https://sourcegraph.com https://docs.sourcegraph.com/cli"
SRC_URI="https://github.com/sourcegraph/src-cli/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build ./cmd/src
}

src_install() {
	dobin src
	dodoc AUTH_PROXY.md CHANGELOG.md
}
