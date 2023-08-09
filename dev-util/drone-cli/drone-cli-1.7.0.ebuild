# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Command-line interface for Drone"
HOMEPAGE="https://github.com/drone/drone-cli"

SRC_URI="https://github.com/drone/drone-cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT+=" test"

src_compile() {
	ego build \
		-ldflags "-X main.version=${PV}" -o bin/drone ./drone
}

src_install() {
	dobin bin/drone
	dodoc README.md
}
