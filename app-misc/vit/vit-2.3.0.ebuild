# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A lightweight, fast, curses-based front end to Taskwarrior"
HOMEPAGE="
	https://github.com/vit-project/vit
	https://pypi.org/project/vit/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-misc/task
	$(python_gen_cond_dep '
		>=dev-python/tasklib-2.4.3[${PYTHON_USEDEP}]
		>=dev-python/urwid-2.1.2[${PYTHON_USEDEP}]
	')
"

distutils_enable_tests pytest
