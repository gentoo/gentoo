# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} pypy3 )

inherit python-r1

DESCRIPTION="A virtual for Python greenlet module"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/greenlet[${PYTHON_USEDEP}]' 'python*')"
