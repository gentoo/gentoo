# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion

DESCRIPTION="CLI client for Bitwarden compatible servers"
HOMEPAGE="https://github.com/bitwarden/clients/tree/main/apps/cli"

SRC_URI="https://github.com/bitwarden/clients/releases/download/cli-v${PV}/bw-oss-linux-${PV}.zip"

S="${WORKDIR}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

# stripping breaks the binary. Errors:
# Pkg: Error reading from file.
RESTRICT='strip'

BDEPEND="app-arch/unzip"
QA_PREBUILT="usr/bin/bw"

src_compile() {
	./bw completion --shell zsh > bw.zsh 2> /dev/null || die
}

src_install() {
	dobin bw
	newzshcomp bw.zsh _bw
}
