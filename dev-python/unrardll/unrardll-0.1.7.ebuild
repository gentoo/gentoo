# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python wrapper for the UnRAR DLL"
HOMEPAGE="
	https://github.com/kovidgoyal/unrardll
	https://pypi.org/project/unrardll/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# The version constraint is needed to resolve https://bugs.gentoo.org/916036
# and guarantee the headers are findable.
DEPEND=">=app-arch/unrar-6.2.12-r1:="
RDEPEND="${DEPEND}"

distutils_enable_tests unittest

src_prepare() {
	default
	# https://github.com/kovidgoyal/unrardll/pull/5
	mv test/basic.py test/test_basic.py || die
}
