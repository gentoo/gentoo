# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A PyTest plugin which provides an FTP fixture for your tests"
HOMEPAGE="
	https://github.com/oz123/pytest-localftpserver/
	https://pypi.org/project/pytest-localftpserver/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/pyftpdlib[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_IGNORE=(
	# these are broken upstream
	tests/test_pytest_localftpserver_TLS.py
	# TODO
	tests/test_pytest_localftpserver_with_env_var.py
)

EPYTEST_PLUGINS=( "${PN}" )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest
