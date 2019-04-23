# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy pypy3 )

inherit python-r1

DESCRIPTION="A virtual for Python pathlib module"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ia64 ~ppc ppc64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pathlib[${PYTHON_USEDEP}]' \
		python2_7 pypy)"
