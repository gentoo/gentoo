# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="Manage python installations in your system, berdario's shallow fork"
HOMEPAGE="
	https://github.com/berdario/pythonz/tree/bd
	https://pypi.org/project/pythonz-bd/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="$(python_gen_cond_dep 'dev-python/resumable-urlretrieve[${PYTHON_USEDEP}]' 'python3*')"
