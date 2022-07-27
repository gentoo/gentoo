# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="A vulnerability scanner for container images and filesystems"
HOMEPAGE="https://www.anchore.com"
SRC_URI="https://github.com/anchore/grype/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -o bin/grype
}

src_install() {
	dobin bin/grype
}
