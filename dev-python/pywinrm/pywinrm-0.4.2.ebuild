# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Python client for the Windows Remote Management (WinRM) service"
HOMEPAGE="https://github.com/diyan/pywinrm/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="kerberos"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-ntlm[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]
	kerberos? (
		<dev-python/pykerberos-2.0.0[${PYTHON_USEDEP}]
		dev-python/requests-credssp[${PYTHON_USEDEP}]
	)"
BDEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.2_test-installation.patch
)

distutils_enable_tests pytest
