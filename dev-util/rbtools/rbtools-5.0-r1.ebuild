# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Command line tools for use with Review Board"
HOMEPAGE="https://www.reviewboard.org/"
SRC_URI="https://github.com/reviewboard/rbtools/archive/refs/tags/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/rbtools-release-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/certifi-2023.5.7[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	>=dev-python/housekeeping-1.1[${PYTHON_USEDEP}]
	=dev-python/housekeeping-1*[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	=dev-python/pydiffx-1.1*[${PYTHON_USEDEP}]
	dev-python/texttable[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.3.0[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	>=dev-python/importlib-metadata-5.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/kgb-6.1[${PYTHON_USEDEP}]
		dev-python/pytest-env[${PYTHON_USEDEP}]
		dev-vcs/git
		dev-vcs/mercurial
	)
"

PATCHES=( "${FILESDIR}/${P}-importlib-resources.patch" "${FILESDIR}/${P}-scmtool-crash.patch" )

DOCS=( AUTHORS NEWS README.md )

distutils_enable_tests pytest

src_prepare() {
	default

	# Avoid tests requiring unpackaged test data
	rm -f rbtools/clients/tests/test_scanning.py || die

	# Avoid repository specific tests to avoid dependencies on them
	rm -f rbtools/clients/tests/test_{cvs,git,mercurial,svn}.py || die
}
