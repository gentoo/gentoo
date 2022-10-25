# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A utility belt for advanced users of python-requests"
HOMEPAGE="
	https://toolbelt.readthedocs.io/
	https://github.com/requests/toolbelt/
	https://pypi.org/project/requests-toolbelt/
"
SRC_URI="
	https://github.com/requests/toolbelt/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${P#requests-}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	<dev-python/requests-3.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/betamax[${PYTHON_USEDEP}]
	)
"

DOCS=( AUTHORS.rst HISTORY.rst README.rst )

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Internet
	tests/test_multipart_encoder.py::TestFileFromURLWrapper::test_no_content_length_header
	tests/test_multipart_encoder.py::TestFileFromURLWrapper::test_read_file
	tests/test_multipart_encoder.py::TestMultipartEncoder::test_reads_file_from_url_wrapper
)

EPYTEST_IGNORE=(
	# certs have expired
	# (if you ever fix this, look into git history for proper
	# cryptography/pyopenssl logic)
	tests/test_x509_adapter.py
)
