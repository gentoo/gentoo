# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit python-single-r1 vim-plugin

DESCRIPTION="vim plugin: automated tag file generation and syntax highlighting"
HOMEPAGE="http://peterodding.com/code/vim/easytags/"
SRC_URI="https://github.com/xolox/vim-${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-vim/vim-misc
	dev-util/ctags"

VIM_PLUGIN_HELPFILES="${PN}.txt"

S="${WORKDIR}/vim-${P}"

PATCHES=( "${FILESDIR}/${P}-fix-ctags-detection.patch" )

src_prepare() {
	default
	rm addon-info.json INSTALL.md README.md || die
}

src_install() {
	vim-plugin_src_install

	fperms 755 /usr/share/vim/vimfiles/misc/easytags/{normalize-tags,why-so-slow}.py

	# fix scripts
	local f
	for f in $(find "${ED}" -type f -name \*.py); do
		ebegin "Fixing $(basename ${f})"
		if [[ $f =~ highlight.py ]]; then
			sed -e '1 i\#!/usr/bin/env python3' -i "${f}" || die "can't sed patch ${f}"
		fi
		2to3 -w -n --no-diffs "${f}" >& /dev/null || die "can't convert ${f} to Python 3"
		python_fix_shebang -q -f "${f}"
		eend $?
	done
}
