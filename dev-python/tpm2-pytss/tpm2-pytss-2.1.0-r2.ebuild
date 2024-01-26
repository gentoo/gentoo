# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for TSS"
HOMEPAGE="
	https://pypi.org/project/tpm2-pytss
	https://github.com/tpm2-software/tpm2-pytss
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+fapi test"

RDEPEND="${PYTHON_DEPS}
	app-crypt/tpm2-tss:=[fapi=]
	fapi? ( >=app-crypt/tpm2-tss-3.0.3:= )
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/asn1crypto[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pycparser[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	test? ( app-crypt/swtpm )"

BDEPEND="${PYTHON_DEPS}
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/pkgconfig[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${PN}-2.1.0-test-add-check-for-renamed-cryptography-types.patch"
	"${FILESDIR}/${PN}-2.1.0-internal-crypto-fix-_MyRSAPrivateNumbers-with-crypto.patch"
	"${FILESDIR}/${PN}-2.1.0-test-disable-pcr_set_auth_value-and-pcr_set_auth_pol.patch"
	)

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

distutils_enable_tests pytest
