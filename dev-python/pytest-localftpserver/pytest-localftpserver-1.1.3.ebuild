# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A PyTest plugin which provides an FTP fixture for your tests"
HOMEPAGE="https://pypi.org/project/pytest-localserver/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="dev-python/pyftpdlib[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

EPYTEST_IGNORE=(
	# These tests require python wget module, but not in Portage
	tests/test_pytest_localftpserver.py
	tests/test_pytest_localftpserver_TLS.py
	tests/test_pytest_localftpserver_with_env_var.py
)

distutils_enable_tests pytest
