# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: manage your runtimepath"
HOMEPAGE="https://github.com/tpope/vim-pathogen/
  https://www.vim.org/scripts/script.php?script_id=2332"
SRC_URI="https://github.com/tpope/vim-pathogen/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vim-${P}"

LICENSE="vim"
KEYWORDS="amd64 x86 ~x64-macos"
