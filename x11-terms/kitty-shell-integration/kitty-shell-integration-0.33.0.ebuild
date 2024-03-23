# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Shell integration scripts for kitty, a GPU-based terminal emulator"
HOMEPAGE="https://sw.kovidgoyal.net/kitty/"
SRC_URI="https://github.com/kovidgoyal/kitty/releases/download/v${PV}/kitty-${PV}.tar.xz"
S="${WORKDIR}/kitty-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
RESTRICT="test" # intended to be ran on the full kitty package

src_compile() { :; }

src_install() {
	# install the whole directory in the upstream suggested location
	# for consistency (i.e. less variation between distros if someone
	# ssh into Gentoo), then set symlinks to autoload where possible
	# (these exit immediately if KITTY_SHELL_INTEGRATION is unset)
	insinto /usr/share/kitty
	doins -r shell-integration

	dosym -r {/usr/share/kitty/shell-integration/bash,/etc/bash/bashrc.d}/kitty.bash

	dosym -r /usr/share/{kitty/shell-integration/fish,fish}/vendor_completions.d/kitty.fish
	dosym -r /usr/share/{kitty/shell-integration/fish,fish}/vendor_conf.d/kitty-shell-integration.fish

	dosym -r /usr/share/{kitty/shell-integration/zsh/completions,zsh/site-functions}/_kitty
	# zsh integration is handled automatically without needing to modify rc files,
	# but may require user intervention depending on zsh invocation or if remote

	# this is used internally by the ssh kitten and is not useful there
	rm -r "${ED}"/usr/share/kitty/shell-integration/ssh || die
}
