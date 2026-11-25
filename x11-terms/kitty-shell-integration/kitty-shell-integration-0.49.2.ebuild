# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kovidgoyal/kitty.git"
else
	SRC_URI="https://github.com/kovidgoyal/kitty/releases/download/v${PV}/kitty-${PV}.tar.xz"
	S=${WORKDIR}/kitty-${PV}
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

DESCRIPTION="Shell integration scripts for kitty, a GPU-based terminal emulator"
HOMEPAGE="https://sw.kovidgoyal.net/kitty/"

LICENSE="GPL-3"
SLOT="0"
RESTRICT="test" # intended to be ran on the full kitty package

src_compile() { :; }

src_install() {
	# split from the kitty package to allow installing individually on
	# remote machines and have shell integration scripts be auto-loaded
	insinto /etc/bash/bashrc.d
	newins shell-integration/bash/kitty.bash 90-kitty.bash

	insinto /usr/share/fish
	doins -r shell-integration/fish/vendor_conf.d

	# unfortunately zsh currently lacks a bashrc.d equivalent, copy
	# to docdir for now so users can use it manually if needed (also at
	# /usr/lib*/kitty/shell-integration/zsh if kitty is installed)
	docinto zsh
	docompress -x /usr/share/doc/${PF}/zsh
	dodoc shell-integration/zsh/{.zshenv,kitty-integration,kitty.zsh}
}
