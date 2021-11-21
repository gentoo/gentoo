# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 optfeature

MY_P=pyfilesystem2-${PV}
DESCRIPTION="Filesystem abstraction layer"
HOMEPAGE="
	https://pypi.org/project/fs/
	https://docs.pyfilesystem.org
	https://www.willmcgugan.com/tag/fs/
"
# Tests from the PyPI tarball are broken
# https://github.com/PyFilesystem/pyfilesystem2/issues/364
SRC_URI="
	https://github.com/PyFilesystem/pyfilesystem2/archive/v${PV}.tar.gz
		-> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/appdirs-1.4.3[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pyftpdlib[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# TODO: fails at teardown due to unfreed resources
		tests/test_ftpfs.py
	)

	# pytest-xvfb causes test failures due to a zombie Xvfb process
	epytest -p no:xvfb
}

pkg_postinst() {
	optfeature "S3 support" dev-python/boto
	optfeature "SFTP support" dev-python/paramiko
	optfeature "Browser support" dev-python/wxpython
}
