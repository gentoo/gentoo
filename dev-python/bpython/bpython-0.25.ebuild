# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Syntax highlighting and autocompletion for the Python interpreter"
HOMEPAGE="
	https://www.bpython-interpreter.org/
	https://github.com/bpython/bpython/
	https://pypi.org/project/bpython/
"

LICENSE="MIT BSD-2 PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="clipboard +jedi watch"

# see https://github.com/bpython/bpython/issues/641 wrt greenlet
RDEPEND="
	>=dev-python/curtsies-0.4.0[${PYTHON_USEDEP}]
	dev-python/cwcwidth[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	clipboard? ( dev-python/pyperclip[${PYTHON_USEDEP}] )
	jedi? ( dev-python/jedi[${PYTHON_USEDEP}] )
	watch? ( dev-python/watchdog[${PYTHON_USEDEP}] )
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.0.0[${PYTHON_USEDEP}]
	' 3.10)
"
# sphinx is used implicitly to build manpages
BDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"

DOCS=( AUTHORS.rst CHANGELOG.rst )

distutils_enable_sphinx doc/sphinx/source --no-autodoc
distutils_enable_tests unittest
