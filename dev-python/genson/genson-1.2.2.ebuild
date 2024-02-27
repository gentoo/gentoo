# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="GenSON is a powerful, user-friendly JSON Schema generator built in Python"
HOMEPAGE="
	https://github.com/wolverdude/GenSON/
	https://pypi.org/project/genson/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="
	test? (
		dev-python/jsonschema[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare
	# https://github.com/wolverdude/GenSON/pull/70
	sed -i -e 's@TEST_URI@test://@' test/test_builder.py || die
	# known broken in this release
	[[ ${PV} != 1.2.2 ]] && die "Restore test_bin.py!"
	rm test/test_bin.py || die
}
