# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

# update this on every bump
GIT_COMMIT=fe98c8a2

DESCRIPTION="terminal based UI to manage kubernetes clusters"
HOMEPAGE="https://github.com/wagoodman/dive"
SRC_URI="https://github.com/wagoodman/dive/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/dive/releases/download/v${PV}/${P}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # no tests

BDEPEND=">=dev-lang/go-1.24.1"

src_compile() {
	local ldflags=(
		-w
		-X main.version=${PV}
		-X main.commit=${GIT_COMMIT}
		-X main.buildTime=$(date -u +%Y-%m-%dT%H:%M:%SZ)
	)
	ego build -o bin/dive -ldflags "${ldflags[*]}" .
}

src_install() {
	dobin bin/dive
	einstalldocs
}
