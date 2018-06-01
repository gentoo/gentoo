# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit python-r1

DESCRIPTION="A virtual for the Python functools.singledispatch function"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/singledispatch[${PYTHON_USEDEP}]' python2_7 python3_3 pypy)"
