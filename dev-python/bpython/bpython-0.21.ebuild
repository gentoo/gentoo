# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Syntax highlighting and autocompletion for the Python interpreter"
HOMEPAGE="https://www.bpython-interpreter.org/ https://github.com/bpython/bpython https://pypi.org/project/bpython/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/curtsies-0.3.5[${PYTHON_USEDEP}]
	dev-python/cwcwidth[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	dev-python/jedi[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	"
# sphinx is used implicitly to build manpages
BDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	"

DOCS=( AUTHORS.rst CHANGELOG.rst )

distutils_enable_sphinx doc/sphinx/source --no-autodoc
distutils_enable_tests unittest
