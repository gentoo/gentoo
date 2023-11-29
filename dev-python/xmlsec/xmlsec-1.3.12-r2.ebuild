# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=python-xmlsec-${PV}
DESCRIPTION="Python bindings for the XML Security Library"
HOMEPAGE="
	https://github.com/xmlsec/python-xmlsec/
	https://pypi.org/project/xmlsec/
"
SRC_URI="
	https://github.com/xmlsec/python-xmlsec/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"

# Doesn't yet support xmlsec-1.3.0: https://github.com/xmlsec/python-xmlsec/issues/252
RDEPEND="
	<dev-libs/xmlsec-1.3.0:=[openssl]
	dev-python/lxml[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/pkgconfig[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.11-fix-xml-testfail.patch"
)

EPYTEST_DESELECT=(
	# Fragile based on black version?
	tests/test_type_stubs.py::test_xmlsec_constants_stub

	# Broken with xmlsec-1.2.36+.
	# https://github.com/xmlsec/python-xmlsec/issues/244
	tests/test_ds.py::TestSignContext::test_sign_case5
)

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
