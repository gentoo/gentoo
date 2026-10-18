# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion toolchain-funcs

DESCRIPTION="End-to-end encrypted file transfer, a magic wormhole implementation"
HOMEPAGE="https://github.com/psanford/wormhole-william"
SRC_URI="
	https://github.com/psanford/wormhole-william/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/gentoo-golang-dist/wormhole-william/releases/download/v${PV}/${P}-vendor.tar.xz
"

LICENSE="MIT"
# Dependent licenses
LICENSE+="  Apache-2.0 BSD BSD-2 GPL-3 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build

	if ! tc-is-cross-compiler; then
		einfo "generating shell completion files"
		./wormhole-william shell-completion bash > wormhole-william.bash || die
		./wormhole-william shell-completion zsh > wormhole-william.zsh || die
	fi
}

src_test() {
	# run: go test -v ./... --timeout 60s
	ego test
}

src_install() {
	einstalldocs
	dobin wormhole-william

	if ! tc-is-cross-compiler; then
		newbashcomp wormhole-william.bash wormhole-william
		newzshcomp wormhole-william.zsh _wormhole-william
	else
		ewarn "Shell completion files not installed! Install them manually with '${PN} completion -h'"
	fi
}
