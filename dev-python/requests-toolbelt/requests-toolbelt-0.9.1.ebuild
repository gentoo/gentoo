# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="A utility belt for advanced users of python-requests"
HOMEPAGE="https://toolbelt.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~x64-macos"
IUSE="test"

RDEPEND="<dev-python/requests-3.0.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/betamax[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
	)"

DOCS=( AUTHORS.rst HISTORY.rst README.rst )

PATCHES=(
	"${FILESDIR}/requests-toolbelt-0.8.0-test-tracebacks.patch"
	"${FILESDIR}/requests-toolbelt-0.9.1-tests.patch"

	"${FILESDIR}/requests-toolbelt-0.9.1-py310.patch"
)

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		tests/test_multipart_encoder.py::TestFileFromURLWrapper::test_no_content_length_header
		tests/test_multipart_encoder.py::TestFileFromURLWrapper::test_read_file
		tests/test_multipart_encoder.py::TestMultipartEncoder::test_reads_file_from_url_wrapper
	)

	epytest
}
