# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Use Database URLs in your Django Application"
HOMEPAGE="
	https://github.com/jazzband/dj-database-url/
	https://pypi.org/project/dj-database-url/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.10.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_test() {
	eunittest -s tests
}
