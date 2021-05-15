# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Symbolic constants in Python"
HOMEPAGE="https://github.com/twisted/constantly https://pypi.org/project/constantly/"
SRC_URI="https://github.com/twisted/constantly/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-python/twisted[${PYTHON_USEDEP}] )
"

distutils_enable_tests setup.py
