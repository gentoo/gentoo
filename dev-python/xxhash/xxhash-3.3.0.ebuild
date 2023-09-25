# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python binding for the xxHash library"
HOMEPAGE="
	https://github.com/ifduyue/python-xxhash/
	https://pypi.org/project/xxhash/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

DEPEND="
	>=dev-libs/xxhash-0.8.0
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_configure_all() {
	export XXHASH_LINK_SO=1
}

python_test() {
	cd tests || die
	eunittest
}
