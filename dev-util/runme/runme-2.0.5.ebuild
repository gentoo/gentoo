# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

# fix these on every bump
GIT_SHA=bed11d0ed538857f007c55d2ce70905a94111130
GIT_SHA_SHORT=bed11d0
VERSION=v${PV}-${GIT_SHA_SHORT}

DESCRIPTION="Execute your runbooks, docs and READMEs"
HOMEPAGE="https://runme.dev"
SRC_URI="https://github.com/stateful/runme/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

unset LDFLAGS

src_compile() {
	emake \
		GIT_SHA="${GIT_SHA}" \
		GIT_SHA_SHORT="${GIT_SHA_SHORT}" \
		VERSION="${VERSION}"
}

src_install() {
	dobin runme
	einstalldocs
}
