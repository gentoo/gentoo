# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A simple, easy-to-set-up Git web viewer"
HOMEPAGE="https://github.com/jonashaag/klaus/"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ctags"

RDEPEND="
	>=dev-python/dulwich-0.19.3[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/httpauth[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	ctags? ( dev-python/python-ctags[${PYTHON_USEDEP}] )
"

# The tests can only be run from a git repository
# so they are not included in the source distributions

python_install_all() {
	distutils-r1_python_install_all
	doman ${PN}.1
}
