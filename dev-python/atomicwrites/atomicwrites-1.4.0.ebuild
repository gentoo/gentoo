# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( pypy3 python{2_7,3_{6,7,8,9}} )

inherit distutils-r1

DESCRIPTION="Atomic file writes"
HOMEPAGE="https://github.com/untitaker/python-atomicwrites"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/mock[${PYTHON_USEDEP}]
		' -2)
	)"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme
