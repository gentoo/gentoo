# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A shell parser, formatter, and interpreter with bash support"
HOMEPAGE="https://github.com/mvdan/sh"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/mvdan/sh.git"
	inherit git-r3
else
	SRC_URI="https://github.com/mvdan/sh/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
	S="${WORKDIR}/${PN//fmt/}-${PV}"
fi

LICENSE="Apache-2.0 BSD"
SLOT="0"
IUSE="+man"

BDEPEND="man? ( app-text/scdoc )"

src_unpack() {
	default
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	fi
}

src_compile() {
	# Not bothering with gosh for now as it's very new
	# https://github.com/mvdan/sh#gosh
	ego build ./cmd/shfmt
	if use man; then
		scdoc <cmd/shfmt/shfmt.1.scd >shfmt.1 || die "conversation of man page failed"
	fi
}

src_test() {
	cd syntax || die
	ego test -run=-
}

src_install() {
	dobin shfmt
	if use man; then
		doman shfmt.1
	fi
}
