# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: modular vim framework"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=3631 https://github.com/vim-scripts/frawor"
SRC_URI="https://github.com/vim-scripts/frawor/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="vim"
KEYWORDS="~amd64 ~x86"

# Tests rely on zsh. No.
RESTRICT="test"
