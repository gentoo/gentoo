# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion sysroot

DESCRIPTION="Fast linters runner for Go"
HOMEPAGE="https://golangci-lint.run/ https://github.com/golangci/golangci-lint"
SRC_URI="https://github.com/golangci/golangci-lint/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="GPL-3"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 GPL-3 ISC MIT MPL-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=dev-lang/go-1.26.1"

src_compile() {
	emake build

	einfo "generating shell completion files"
	sysroot_try_run_prefixed ./golangci-lint completion bash > ${PN}.bash || die
	sysroot_try_run_prefixed ./golangci-lint completion zsh > ${PN}.zsh || die
	sysroot_try_run_prefixed ./golangci-lint completion fish > ${PN}.fish || die
}

src_test() {
	emake test
}

src_install() {
	dobin golangci-lint
	local DOCS=( README.md CHANGELOG.md )
	einstalldocs

	[[ -s ${PN}.bash ]] && newbashcomp ${PN}.bash ${PN}
	[[ -s ${PN}.zsh ]] && newzshcomp ${PN}.zsh _${PN}
	[[ -s ${PN}.fish ]] && dofishcomp ${PN}.fish
}
