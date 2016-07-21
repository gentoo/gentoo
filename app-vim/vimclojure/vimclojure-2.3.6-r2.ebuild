# Copyright 1999-2016 Gentoo Foundation
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

RDEPEND="dev-lang/clojure"

S="${WORKDIR}/${MY_PN}-${PV}"

# Files with similar names are already installed by app-vim/slimv.
DUPLICATE_FILES=(
	indent/clojure.vim
	ftdetect/clojure.vim
)

src_prepare() {
	find . -type f -name \*.bat -exec rm -v {} \; || die

	# Let's simply rename them.
	for file in "${DUPLICATE_FILES[@]}"; do
		[[ -f "${file}" ]] || die "Couldn't find: ${file}"
		bname="${file##*/}"
		path="${file%/*}"
		noext="${bname%%.*}"
		newname="${path}/${PN}_${noext}.vim"
		mv "${file}" "${newname}" || die
	done
}

src_install() {
	local my_license="doc/LICENSE.txt"
	dodoc "${my_license}"
	rm -v "${my_license}" || die
	vim-plugin_src_install
}
