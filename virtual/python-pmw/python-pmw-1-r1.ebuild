# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit python-r1

DESCRIPTION="A virtual for pmw, for Python 2 & 3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pmw:py2[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep 'dev-python/pmw:py3[${PYTHON_USEDEP}]' python3_{5,6,7})"
