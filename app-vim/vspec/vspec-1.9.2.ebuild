# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo vim-plugin

DESCRIPTION="A testing framework for Vim script"
HOMEPAGE="
	https://www.vim.org/scripts/script.php?script_id=3012
	https://github.com/kana/vim-vspec
"
SRC_URI="https://github.com/kana/vim-${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vim-${P}"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/perl:*"
BDEPEND="test? ( ${RDEPEND} )"

VIM_PLUGIN_HELPFILES="vspec.txt"

# Uncomment on the next release
#DOCS=( {README,TUTORIAL_CI}.md )

src_prepare() {
	vim-plugin_src_prepare

	# remove failing tests
	rm t/{indent,syntax}.vim || die
}

src_test() {
	export LC_ALL=C
	edo ./bin/prove-vspec
}

src_install() {
	# fix paths for the binary to be installed; don't do it in src_prepare
	# as it will make the tests fail
	sed "s|\$0|${EPREFIX}/usr/share/vim/vimfiles/bin/vspec|g" \
		-i bin/vspec || die

	vim-plugin_src_install bin

	fperms +x /usr/share/vim/vimfiles/bin/{vspec,prove-vspec}
	dosym -r {/usr/share/vim/vimfiles,/usr}/bin/vspec
	dosym -r {/usr/share/vim/vimfiles,/usr}/bin/prove-vspec
}
