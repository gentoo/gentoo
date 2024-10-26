# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="A Go tool to auto generate methods for your enums"
HOMEPAGE="https://github.com/dmarkham/enumer"
SRC_URI="https://github.com/dmarkham/enumer/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="BSD-2"
LICENSE+=" BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
DOCS=(README.md)

src_prepare() {
	default
	local sed_args=()
	# -buildmode=pie not supported when -race is enabled
	[[ ${GOFLAGS} == *buildmode=pie* ]] && sed_args+=(
		-e 's/ -race / /'
	)
	if [[ ${#sed_args[@]} -gt 0 ]]; then
		sed  "${sed_args[@]}" -i Makefile || die
	fi
}

src_compile() {
	CGO_ENABLED=0 ego build -a -o ./enumer .
}

src_install() {
	einstalldocs
	dobin "${PN}"
}

src_test() {
	emake test
}
