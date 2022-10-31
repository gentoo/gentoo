# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="py.test plugin that allows you to add environment variables"
HOMEPAGE="https://github.com/pytest-dev/pytest-env"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P/-/_}.tar.gz"
S="${WORKDIR}/${P/-/_}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"
BDEPEND="dev-python/hatch-vcs[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
