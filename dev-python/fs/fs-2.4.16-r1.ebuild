# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# py3.14: https://github.com/PyFilesystem/pyfilesystem2/issues/596
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Filesystem abstraction layer"
HOMEPAGE="
	https://github.com/PyFilesystem/pyfilesystem2/
	https://pypi.org/project/fs/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/appdirs-1.4.3[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
"
# NB: we skip tests requiring pyftpdlib
BDEPEND="
	test? (
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/source dev-python/sphinx-rtd-theme dev-python/recommonmark
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# TODO: fails at teardown due to unfreed resources
	tests/test_ftpfs.py
)

src_prepare() {
	# fix for python 3.12
	sed -i -e 's/self.assertRaisesRegexp/self.assertRaisesRegex/g' fs/test.py || die

	# remove explicit namespace (this is the only package in the namespace)
	sed -i -e '/pkg_resources/d' fs/__init__.py || die

	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "S3 support" dev-python/boto
	optfeature "SFTP support" dev-python/paramiko
	optfeature "Browser support" dev-python/wxpython
}
