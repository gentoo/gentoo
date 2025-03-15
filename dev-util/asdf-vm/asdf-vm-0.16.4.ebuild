# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module unpacker

DESCRIPTION="Extendable version manager with support for many languages"
HOMEPAGE="https://asdf-vm.com/"

SRC_URI="
	https://github.com/asdf-vm/asdf/archive/refs/tags/v${PV}.tar.gz -> asdf-${PV}.tar.gz
	https://github.com/sin-ack/gentoo-vendor/releases/download/${P}/${P}-vendor.tar.zst
"
S="${WORKDIR}/asdf-${PV}"

# Obtained with `go-licenses csv ./cmd/asdf | cut -d, -f3 | sort -u'
LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-vcs/git"

src_compile() {
	local args=(
		-ldflags="-s -X main.version=${PV}"
		./cmd/asdf
	)

	ego build "${args[@]}"
}

src_install() {
	dobin asdf
	dodoc help.txt

	insinto /usr/share/bash-completion/completions
	newins internal/completions/asdf.bash asdf
	insinto /usr/share/zsh/site-functions
	newins internal/completions/asdf.zsh _asdf
	insinto /usr/share/fish/vendor_completions.d
	doins internal/completions/asdf.fish
}

pkg_postinst() {
	einfo ""
	einfo "To finish installing asdf, follow the shell configuration guide"
	einfo "on the asdf website:"
	einfo ""
	einfo "    https://asdf-vm.com/guide/getting-started.html#_2-configure-asdf"
	einfo ""
}
