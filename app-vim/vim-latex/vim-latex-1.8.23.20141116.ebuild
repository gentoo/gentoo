# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit vim-plugin versionator python-single-r1 eutils

MY_REV="812-gitd0f31c9"
MY_P="${PN}-$( replace_version_separator 3 - ).${MY_REV}"

DESCRIPTION="vim plugin: a comprehensive set of tools to view, edit and compile LaTeX documents"
HOMEPAGE="http://vim-latex.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="vim"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="html python"

RDEPEND="|| ( app-editors/vim[python?] app-editors/gvim[python?] )
	virtual/latex-base"

S=${WORKDIR}/${MY_P}

VIM_PLUGIN_HELPFILES="latex-suite.txt latex-suite-quickstart.txt latexhelp.txt imaps.txt"

src_prepare() {
	# The makefiles do weird stuff, including running the svn command
	rm Makefile Makefile.in || die "rm Makefile Makefile.in failed"

	epatch_user
}

src_install() {
	use html && dohtml -r doc/

	# Don't mess up vim's doc dir with random files
	mv doc mydoc || die
	mkdir doc || die
	mv mydoc/*.txt doc/ || die
	rm -rf mydoc || die

	# Don't install buggy tags scripts, use ctags instead
	rm latextags ltags || die

	vim-plugin_src_install

	# Use executable permissions (bug #352403)
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
