# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="General-purpose retrying library"
HOMEPAGE="
	https://github.com/jd/tenacity/
	https://pypi.org/project/tenacity/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		www-servers/tornado[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	if ! has_version "dev-python/typeguard[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/test_tenacity.py::TestRetryTyping::test_retry_type_annotations
		)
	fi

	epytest
}
