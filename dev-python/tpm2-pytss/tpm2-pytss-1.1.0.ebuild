# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python bindings for TSS"
HOMEPAGE="https://pypi.org/project/tpm2-pytss/"
SRC_URI="https://github.com/tpm2-software/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+fapi test"

RDEPEND="app-crypt/tpm2-tss:=[fapi=]
	fapi? ( >=app-crypt/tpm2-tss-3.0.3:= )
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/asn1crypto[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pycparser[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	test? ( app-crypt/swtpm )"

BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/pkgconfig[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	cd ${T}
	PYTHONPATH="${BUILD_DIR}/install/$(python_get_sitedir):${S}:${PYTHONPATH}" \
	epytest ${S}/test --import-mode=importlib
}
