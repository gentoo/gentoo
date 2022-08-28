# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

MY_PN="VimClojure"

DESCRIPTION="vim plugin: Clojure syntax highlighting, filetype and indent settings"
HOMEPAGE="https://github.com/vim-scripts/VimClojure"
SRC_URI="https://github.com/vim-scripts/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
SLOT="0"

RDEPEND="dev-lang/clojure"

S="${WORKDIR}/${MY_PN}-${PV}"

DOCS=( README README.markdown )

# Files with similar names are already installed by app-vim/slimv.
DUPLICATE_FILES=(
	indent/clojure.vim
	ftdetect/clojure.vim
)

src_prepare() {
	default

	# Remove .bat files.
	find . -type f -name \*.bat -exec rm -v {} \; || die

	# Let's simply rename ${DUPLICATE_FILES[@]}.
	local f
	for f in "${DUPLICATE_FILES[@]}"; do
		[[ -f "${f}" ]] || die "Couldn't find ${f}"
		bname="${f##*/}"
		path="${f%/*}"
		noext="${bname%%.*}"
		newname="${path}/${PN}_${noext}.vim"
		mv -v "${f}" "${newname}" || die
	done
}

src_install() {
	rm -rv doc/LICENSE.txt bin || die
	vim-plugin_src_install
}
