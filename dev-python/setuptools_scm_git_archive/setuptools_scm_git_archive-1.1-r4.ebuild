# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="A setuptools_scm plugin for git archives"
HOMEPAGE="https://github.com/Changaco/setuptools_scm_git_archive"
SRC_URI="https://github.com/Changaco/setuptools_scm_git_archive/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~ppc64 ~riscv ~sparc x86"
IUSE=""

RDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

distutils_enable_tests pytest

src_prepare() {
	export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
	distutils-r1_src_prepare
}

python_test() {
	epytest tests.py
}
