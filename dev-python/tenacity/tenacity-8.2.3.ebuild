# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="General-purpose retrying library"
HOMEPAGE="
	https://github.com/jd/tenacity/
	https://pypi.org/project/tenacity/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/tornado[${PYTHON_USEDEP}]
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
