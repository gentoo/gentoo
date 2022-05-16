# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A setuptools_scm plugin for git archives"
HOMEPAGE="
	https://github.com/Changaco/setuptools_scm_git_archive/
	https://pypi.org/project/setuptools_scm_git_archive/
"
SRC_URI="
	https://github.com/Changaco/setuptools_scm_git_archive/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE=""

RDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"

python_test() {
	epytest tests.py
}
