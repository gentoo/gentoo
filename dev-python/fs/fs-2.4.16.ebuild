# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Filesystem abstraction layer"
HOMEPAGE="
	https://pypi.org/project/fs/
	https://docs.pyfilesystem.org/
	https://www.willmcgugan.com/tag/fs/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/appdirs-1.4.3[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-lang/python-3.12.0_p1
	' python3_12)
"
# NB: we skip tests requiring pyftpdlib
BDEPEND="
	test? (
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/source dev-python/sphinx-rtd-theme dev-python/recommonmark
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# TODO: fails at teardown due to unfreed resources
	tests/test_ftpfs.py
)

src_prepare() {
	# fix for python 3.12
	sed -e 's/self.assertRaisesRegexp/self.assertRaisesRegex/g' -i fs/test.py || die

	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "S3 support" dev-python/boto
	optfeature "SFTP support" dev-python/paramiko
	optfeature "Browser support" dev-python/wxpython
}
