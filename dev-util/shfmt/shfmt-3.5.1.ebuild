# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="shell script formatter"
HOMEPAGE="https://github.com/mvdan/sh"
SRC_URI="https://github.com/mvdan/sh/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Clear-BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-text/scdoc"

S="${WORKDIR}/sh-${PV}"

src_compile() {
	ego build ./cmd/shfmt
	scdoc < ./cmd/shfmt/shfmt.1.scd > shfmt.1 || die
}

src_install() {
	dobin shfmt
	doman shfmt.1
}
