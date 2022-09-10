# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit go-module

DESCRIPTION="A command-line tool for Amazon Route 53"
HOMEPAGE="https://github.com/barnybug/cli53"
SRC_URI="https://github.com/barnybug/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT BSD BSD-2 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# gucumber is required to run tests which is not yet packaged
RESTRICT="strip test"

DEPEND=">=dev-lang/go-1.14"

DOCS=( CHANGELOG.md README.md )

src_compile() {
	GOBIN="${S}/bin" \
		emake install
}

src_install() {
	dobin bin/${PN}
	einstalldocs
}
