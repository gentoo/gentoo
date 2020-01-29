# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit eutils distutils-r1

DESCRIPTION="An implementation of the Language Server Protocol for Python"
HOMEPAGE="https://github.com/palantir/python-language-server"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/versioneer[${PYTHON_USEDEP}]"

RDEPEND="dev-python/jedi[${PYTHON_USEDEP}]
	dev-python/pluggy[${PYTHON_USEDEP}]
	dev-python/python-jsonrpc-server[${PYTHON_USEDEP}]
	dev-python/ujson[${PYTHON_USEDEP}]"

pkg_postinst() {
	elog "To get additional features, optional runtime dependencies may be installed:"
	optfeature "Automatically formats Python code to conform to the PEP 8 style guide" dev-python/autopep8
	optfeature "A wrapper around PyFlakes, pep8 & mccabe" dev-python/flake8
	optfeature "flake8 plugin: McCabe complexity checker" dev-python/mccabe
	optfeature "Python style guide checker (fka pep8)" dev-python/pycodestyle
	optfeature "Passive checker for Python programs" sci-libs/pyflakes
	optfeature "Python code static checker" dev-python/pylint
	optfeature "Python refactoring library" dev-python/rope
	optfeature "A formatter for Python files" dev-python/yapf
}
