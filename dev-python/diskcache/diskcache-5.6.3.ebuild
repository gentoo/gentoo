# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Disk and file backed cache"
HOMEPAGE="
	https://grantjenks.com/docs/diskcache/
	https://github.com/grantjenks/python-diskcache/
	https://pypi.org/project/diskcache/
"
SRC_URI="
	https://github.com/grantjenks/python-diskcache/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/python-diskcache-${PV}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		>=dev-python/django-3.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

src_prepare() {
	# remove dep on pytest-xdist and pytest-cov
	sed -i -e '/-n auto/d' -e '/--cov/d' tox.ini || die

	distutils-r1_src_prepare
}
