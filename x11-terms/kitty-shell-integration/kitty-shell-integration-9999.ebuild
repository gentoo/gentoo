# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kovidgoyal/kitty.git"
else
	SRC_URI="https://github.com/kovidgoyal/kitty/releases/download/v${PV}/kitty-${PV}.tar.xz"
	S=${WORKDIR}/kitty-${PV}
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

DESCRIPTION="Shell integration scripts for kitty, a GPU-based terminal emulator"
HOMEPAGE="https://sw.kovidgoyal.net/kitty/"

LICENSE="GPL-3"
SLOT="0"
RESTRICT="test" # intended to be ran on the full kitty package

src_compile() { :; }

src_install() {
	# install the whole directory in the upstream suggested location
	# for consistency (i.e. less variation between distros if someone
	# ssh into Gentoo), then set symlinks to autoload where possible
	# (these exit immediately if KITTY_SHELL_INTEGRATION is unset)
	insinto /usr/share/kitty
	doins -r shell-integration

	dosym -r {/usr/share/kitty/shell-integration/bash/,/etc/bash/bashrc.d/90-}kitty.bash

	dosym -r /usr/share/{kitty/shell-integration/fish,fish}/vendor_completions.d/kitty.fish
	dosym -r /usr/share/{kitty/shell-integration/fish,fish}/vendor_conf.d/kitty-shell-integration.fish

	dosym -r /usr/share/{kitty/shell-integration/zsh/completions,zsh/site-functions}/_kitty
	# zsh integration is handled automatically without needing to modify rc files,
	# but may require user intervention depending on zsh invocation or if remote

	# this is used internally by the ssh kitten and is not useful there
	rm -r "${ED}"/usr/share/kitty/shell-integration/ssh || die
}
