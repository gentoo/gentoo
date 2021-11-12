# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="Classes for orchestrating Python (virtual) environments."
HOMEPAGE="https://github.com/jaraco/jaraco.envs"
SRC_URI="mirror://pypi/${MY_P::1}/${PN/-/.}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"

RDEPEND="
	dev-python/path-py[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/contextlib2[${PYTHON_USEDEP}]' 'python3_[67]')"
# toml is required by setuptools_scm
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]"

# there are no actual tests, just flake8 etc
RESTRICT="test"
