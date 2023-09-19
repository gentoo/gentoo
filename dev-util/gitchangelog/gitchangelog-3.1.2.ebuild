# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Creates a nicely formatted changelog from git log history"
HOMEPAGE="https://github.com/sarnold/gitchangelog"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/gitchangelog.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/${PN}/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="doc"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-python/minimock[${PYTHON_USEDEP}] )
"

RDEPEND="
	dev-python/pystache[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
"

# needs versioningit if building from git repo source
if [[ ${PV} = 9999* ]]; then
	BDEPEND="
		$(python_gen_any_dep '
			>=dev-python/versioningit-2.0.0[${PYTHON_USEDEP}]
		')"
fi

DOCS=( README.rst )

distutils_enable_sphinx \
	docs/source \
	dev-python/sphinx-rtd-theme \
	dev-python/recommonmark \
	dev-python/sphinxcontrib-apidoc

distutils_enable_tests pytest

python_test() {
	epytest --doctest-modules .
}
