# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion toolchain-funcs

DESCRIPTION="Fast linters runner for Go"
HOMEPAGE="https://golangci-lint.run/ https://github.com/golangci/golangci-lint"
SRC_URI="https://github.com/golangci/golangci-lint/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="GPL-3"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 GPL-3 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake build

	if ! tc-is-cross-compiler; then
		einfo "generating shell completion files"
		./golangci-lint completion bash > ${PN}.bash || die
		./golangci-lint completion zsh > ${PN}.zsh || die
		./golangci-lint completion fish > ${PN}.fish || die
	fi
}

src_test() {
	emake test
}

src_install() {
	dobin golangci-lint
	local DOCS=( README.md CHANGELOG.md )
	einstalldocs

	if ! tc-is-cross-compiler; then
		newbashcomp ${PN}.bash ${PN}
		newzshcomp ${PN}.zsh _${PN}
		dofishcomp ${PN}.fish
	else
		ewarn "Shell completion files not installed! Install them manually with '${PN} completion --help'"
	fi
}
