# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vim-plugin

MY_PN="VimClojure"

DESCRIPTION="vim plugin: Clojure syntax highlighting, filetype and indent settings"
HOMEPAGE="https://github.com/vim-scripts/VimClojure"
SRC_URI="https://github.com/vim-scripts/${MY_PN}/archive/${PV}.zip"
SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!app-vim/slivm"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	find . -type f -name \*.bat -exec rm -v {} \; || die
}

src_install() {
	local my_license="doc/LICENSE.txt"
	dodoc ${my_license}
	rm -v ${my_license} || die
	vim-plugin_src_install
}
