# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

# fix these on every bump
GIT_SHA=2a93bf599805ca258e81eef1d5784fb1266cac78
GIT_SHA_SHORT=2a93bf5
VERSION=v${PV}-${GIT_SHA_SHORT}

DESCRIPTION="Execute your runbooks, docs and READMEs"
HOMEPAGE="https://runme.dev"
SRC_URI="https://github.com/stateful/runme/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

unset LDFLAGS
QA_PRESTRIPPED=usr/bin/runme

# direnv isn't available on Gentoo and is required for tests.
RESTRICT="test"

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

src_test() {
	emake \
		GIT_SHA="${GIT_SHA}" \
		GIT_SHA_SHORT="${GIT_SHA_SHORT}" \
		VERSION="${VERSION}" \
		test
}
