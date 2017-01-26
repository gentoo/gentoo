# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="transparent editing of gpg encrypted files"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3645"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm x86"

RDEPEND="app-crypt/gnupg"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	default

	# There's good documentation included with the script, but it's not
	# in a helpfile. Since there's rather too much information to include
	# in a VIM_PLUGIN_HELPTEXT, we'll sed ourselves a help doc.
	mkdir doc || die
	sed -e '/" Section: Plugin header.\+$/,9999d' -e 's/^" \?//' \
		-e 's/\(Name:\s\+\)\([^.]\+\)\.vim/\1*\2.txt*/' \
		plugin/${PN}.vim \
		> doc/${PN}.txt || die
}
