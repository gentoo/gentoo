# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

EGIT_COMMIT=0607aa5
DESCRIPTION="Pure Go implementation of jq with yaml support"
HOMEPAGE="https://github.com/itchyny/gojq"
SRC_URI="https://github.com/itchyny/gojq/archive/refs/tags/v${PV}.tar.gz -> ${P/-go/}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P/-go/}-deps.tar.xz"

LICENSE="MIT"
LICENSE+=" Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"
DOCS=(README.md)

src_prepare() {
	default
	local -a sed_args=(
		-e "s/^VERSION := .*/VERSION := ${PV}/"
		-e "s/^CURRENT_REVISION = .*/CURRENT_REVISION = ${EGIT_COMMIT}/"
	)
	# -buildmode=pie not supported when -race is enabled
	[[ ${GOFLAGS} == *buildmode=pie* ]] && sed_args+=(
		-e 's/ -race / /'
	)
	sed  "${sed_args[@]}" -i Makefile || die
}

src_compile() {
	emake build
}

src_install() {
	einstalldocs
	dobin "${PN}"
}

src_test() {
	emake test
}
