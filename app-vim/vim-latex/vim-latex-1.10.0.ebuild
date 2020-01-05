# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )

inherit vim-plugin python-single-r1

DESCRIPTION="A comprehensive set of tools to view, edit and compile LaTeX documents"
HOMEPAGE="http://vim-latex.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="vim"
KEYWORDS="alpha amd64 ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	|| (
		app-editors/vim[python,${PYTHON_USEDEP}]
		app-editors/gvim[python,${PYTHON_USEDEP}]
	)
	virtual/latex-base
	!app-vim/vimtex"

VIM_PLUGIN_HELPFILES="latex-suite.txt latex-suite-quickstart.txt latexhelp.txt imaps.txt"

src_compile() { :; }

src_install() {
	# remove unused metadata
	rm vim-latex.metainfo.xml || die

	# don't mess up vim's doc dir with random files
	mv doc mydoc || die
	mkdir doc || die
	mv mydoc/*.txt doc/ || die
	rm -rf mydoc || die

	# don't install buggy tags scripts, use ctags instead
	rm latextags ltags || die

	vim-plugin_src_install

	# use executable permissions (bug #352403)
	fperms a+x /usr/share/vim/vimfiles/ftplugin/latex-suite/outline.py

	python_fix_shebang "${ED}"
}

pkg_postinst() {
	vim-plugin_pkg_postinst

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		echo
		elog "To use the vim-latex plugin add:"
		elog "   filetype plugin on"
		elog '   set grepprg=grep\ -nH\ $*'
		elog "   let g:tex_flavor='latex'"
		elog "to your ~/.vimrc-file"
		echo
	fi
}
