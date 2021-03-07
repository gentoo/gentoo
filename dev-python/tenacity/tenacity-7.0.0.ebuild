# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="General-purpose retrying library"
HOMEPAGE="https://github.com/jd/tenacity"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		www-servers/tornado[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# TODO: package typeguard
		tenacity/tests/test_tenacity.py::TestRetryTyping::test_retry_type_annotations
	)

	pytest -vv ${deselect[@]/#/--deselect } ||
		die "Tests failed with ${EPYTHON}"
}
