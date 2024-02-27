# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 go-module systemd

DESCRIPTION="Easily and securely send things from one computer to another"
HOMEPAGE="https://github.com/schollz/croc"
SRC_URI="https://github.com/schollz/croc/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
https://dev.gentoo.org/~xgqt/distfiles/deps/${P}-vendor.tar.xz
"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	acct-group/croc
	acct-user/croc
"

DOCS=( README.md )

src_prepare() {
	default
	# Replace User=nobody with User=croc
	sed -i -e "s|\(^User=\).*|\1croc|g" croc.service || die
	# Rename bash completion function
	sed -i -e "s|_cli_bash_autocomplete|_croc|g" \
		src/install/bash_autocomplete || die
}

src_compile() {
	ego build
}

src_install() {
	dobin croc
	systemd_dounit croc.service
	newbashcomp src/install/bash_autocomplete croc
	einstalldocs
}

src_test() {
	ego test -work ./...
}
