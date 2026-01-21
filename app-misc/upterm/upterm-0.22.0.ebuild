# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion systemd

DESCRIPTION="Instant Terminal Sharing"
HOMEPAGE="https://upterm.dev/"
SRC_URI="https://github.com/owenthereal/upterm/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/upterm/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 CC0-1.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="server test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-lang/go-1.25.4
	test? (
		app-editors/vim
		app-shells/bash
	)
"

src_compile() {
	local BINS=( ./cmd/upterm )
	use server && BINS+=( ./cmd/uptermd )
	ego build -o bin/ "${BINS[@]}"
}

src_test() {
	ego test -vet=off -timeout=120s ./{cmd,server,io,host,memlistener,routing,internal,ftests}/...
}

src_install() {
	dobin bin/upterm
	doman etc/man/man1/*

	newbashcomp etc/completion/upterm.bash_completion.sh upterm
	newzshcomp etc/completion/upterm.zsh_completion _upterm

	if use server; then
		dobin bin/uptermd
		systemd_dounit systemd/uptermd.service
	fi
}
