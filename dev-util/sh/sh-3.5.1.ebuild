# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A shell parser, formatter, and interpreter with bash support"
HOMEPAGE="https://github.com/mvdan/sh"
SRC_URI="https://github.com/mvdan/sh/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	# Not bothering with gosh for now as it's very new
	# https://github.com/mvdan/sh#gosh
	ego build ./cmd/shfmt
}

src_test() {
	cd syntax || die
	ego test -run=-
}

src_install() {
	dobin shfmt
}
