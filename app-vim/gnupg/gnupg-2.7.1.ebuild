# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="transparent editing of gpg encrypted files"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=3645"
SRC_URI="https://www.vim.org/scripts/download_script.php?src_id=27359 -> ${P}.zip"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm x86"

S="${WORKDIR}/vim-${P}"

RDEPEND="app-crypt/gnupg"

BDEPEND="app-arch/unzip"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	default

	# There's good documentation included with the script, but it's not
	# in a helpfile. Since there's rather too much information to include
	# in a VIM_PLUGIN_HELPTEXT, we'll sed ourselves a help doc.
	sed -e '/" Section: Plugin header.\+$/,9999d' -e 's/^" \?//' \
		-e 's/\(Name:\s\+\)\([^.]\+\)\.vim/\1*\2.txt*/' \
		plugin/${PN}.vim \
		> doc/${PN}.txt || die
}
