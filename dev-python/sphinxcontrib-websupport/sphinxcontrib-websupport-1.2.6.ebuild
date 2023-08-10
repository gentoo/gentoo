# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx websupport extension"
HOMEPAGE="
	https://www.sphinx-doc.org/
	https://github.com/sphinx-doc/sphinxcontrib-websupport/
	https://pypi.org/project/sphinxcontrib-websupport/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/sphinxcontrib-serializinghtml[${PYTHON_USEDEP}]
"
# avoid circular dependency with sphinx
PDEPEND="
	>=dev-python/sphinx-5[${PYTHON_USEDEP}]
"
# there are additional optional test deps on sqlalchemy and whoosh
# but they're broken with sqlalchemy-2.0
# https://github.com/sphinx-doc/sphinxcontrib-websupport/issues/61
BDEPEND="
	test? (
		${PDEPEND}
	)
"

distutils_enable_tests pytest
