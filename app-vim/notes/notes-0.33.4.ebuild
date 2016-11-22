# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit python-single-r1 vim-plugin

DESCRIPTION="vim plugin: easy note taking in vim"
HOMEPAGE="http://peterodding.com/code/vim/notes/"
SRC_URI="https://github.com/xolox/vim-notes/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=app-vim/vim-misc-1.17.6"

VIM_PLUGIN_HELPFILES="${PN}.txt"

S=${WORKDIR}/vim-${P}

src_prepare() {
	# remove unnecessary files
	rm addon-info.json INSTALL.md README.md || die

	python_fix_shebang .
}
