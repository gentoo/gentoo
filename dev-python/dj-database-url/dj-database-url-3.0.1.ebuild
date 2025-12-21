# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Use Database URLs in your Django Application"
HOMEPAGE="
	https://github.com/jazzband/dj-database-url/
	https://pypi.org/project/dj-database-url/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	>=dev-python/django-4.2[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_test() {
	eunittest -s tests
}
