# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python client for the Windows Remote Management (WinRM) service"
HOMEPAGE="https://github.com/diyan/pywinrm/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv"
IUSE="kerberos"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-ntlm[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]
	kerberos? (
		<dev-python/pykerberos-2.0.0[${PYTHON_USEDEP}]
		dev-python/requests-credssp[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
