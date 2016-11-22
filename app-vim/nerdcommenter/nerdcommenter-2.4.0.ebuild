# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: easy commenting of code for many filetypes"
HOMEPAGE="https://github.com/scrooloose/nerdcommenter http://www.vim.org/scripts/script.php?script_id=1218"
SRC_URI="https://github.com/scrooloose/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="WTFPL-2 "
KEYWORDS="~amd64 ~x86 ~x86-linux ~x86-macos ~sparc64-solaris"

VIM_PLUGIN_HELPFILES="NERD_commenter.txt"

src_prepare() {
	default
	rm README.md Rakefile || die
}
