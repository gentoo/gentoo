# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="doggo is a modern command-line DNS client (like dig) written in Golang"
HOMEPAGE="https://github.com/mr-karan/doggo"
SRC_URI="https://github.com/mr-karan/doggo/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/adamtajti/gentoo-adamtajti/raw/main/deps/doggo-${PV}-deps.tar.xz"
# BSD-3: BSD
LICENSE="GPL-3 BSD Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"
BDEPEND=">=dev-lang/go-1.22"

src_compile() {
	local build_date=$(date '+%Y-%m-%d %H:%M:%S')
	CGO_ENABLED=0 ego build -o "${PN}" \
		-ldflags="-X 'main.buildVersion=${PV}' -X 'main.buildDate=${build_date}'" \
		"./cmd/${PN}"

	mkdir completions
	./doggo completions bash >"completions/${PN}" || die
	./doggo completions fish >"completions/${PN}.fish" || die
	./doggo completions zsh >"completions/_${PN}" || die
}

src_install() {
	dobin "${PN}"

	einstalldocs
	dodoc README.md

	dobashcomp "completions/${PN}"
	dofishcomp "completions/${PN}.fish"
	dozshcomp "completions/_${PN}"
}
