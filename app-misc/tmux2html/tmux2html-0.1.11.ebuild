# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Render full tmux windows or individual panes as HTML"
HOMEPAGE="https://github.com/tweekmonster/tmux2html"
SRC_URI="https://github.com/tweekmonster/tmux2html/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"

RDEPEND="
	app-misc/tmux
	dev-python/setuptools[${PYTHON_USEDEP}]"
