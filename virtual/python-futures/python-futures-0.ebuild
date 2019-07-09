# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy )

inherit python-r1

DESCRIPTION="A virtual for the Python concurrent.futures module"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~amd64-linux"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/futures[${PYTHON_USEDEP}]' python2_7 pypy)"
