# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Micro-framework for developing production-ready web services with Python"
HOMEPAGE="
	https://pypi.org/project/klein/
	https://github.com/twisted/klein/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=dev-python/attrs-20.1.0[${PYTHON_USEDEP}]
	dev-python/hyperlink[${PYTHON_USEDEP}]
	dev-python/incremental[${PYTHON_USEDEP}]
	dev-python/tubes[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.6[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/treq[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Failing hypothesis health checks... so upstream reinvented
	# hypothesis in trunk.  This is too big to backport, and the package
	# is too awful to install from snapshot.
	src/klein/test/test_headers.py::{Frozen,Mutable}HTTPHeadersTests::test_getTextName{,BinaryValues}
	src/klein/test/test_headers_compat.py::HTTPHeadersWrappingHeadersTests::test_getTextName{,BinaryValues}
	src/klein/test/test_response.py::FrozenHTTPResponseTests::test_bodyAsBytesFrom{Bytes,Fount}{,Cached}
	src/klein/test/test_response.py::FrozenHTTPResponseTests::test_bodyAsFountFrom{Bytes,Fount}{,Twice}
)
