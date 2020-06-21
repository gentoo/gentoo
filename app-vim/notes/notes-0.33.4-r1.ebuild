# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

PYTHON_REQ_USE="sqlite"

inherit vim-plugin python-single-r1

DESCRIPTION="vim plugin: easy note taking in vim"
HOMEPAGE="http://peterodding.com/code/vim/notes/"
SRC_URI="https://github.com/xolox/vim-notes/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-vim/vim-misc"

VIM_PLUGIN_HELPFILES="${PN}.txt"

S="${WORKDIR}/vim-${P}"

src_prepare() {
	default

	# remove unnecessary files
	rm addon-info.json INSTALL.md README.md || die

	python_fix_shebang "${S}"
}
