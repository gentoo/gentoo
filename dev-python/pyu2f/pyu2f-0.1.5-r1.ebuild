# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Python based U2F host library"
HOMEPAGE="
	https://github.com/google/pyu2f/
	https://pypi.org/project/pyu2f/
"
SRC_URI="
	https://github.com/google/pyu2f/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/pyfakefs[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

DOCS=( CONTRIBUTING.md README.md )

distutils_enable_tests pytest

python_prepare_all() {
	# https://github.com/google/pyu2f/commit/5e2f862dd5ba61eadff341dbf0a1202e91b1b145
	sed -i -e 's:logger[.]warn:&ing:' pyu2f/hid/macos.py || die
	sed -e "s:CreateFile:create_file:" \
		-e "s:CreateDirectory:create_dir:" \
		-e "s:RemoveObject:remove_object:" \
		-e "s:SetContents:set_contents:" \
		-i pyu2f/tests/hid/linux_test.py || die
	# https://github.com/google/pyu2f/commit/793acd9ff6612bb035f0724b04e10a01cdb5bb8d
	# https://github.com/google/pyu2f/commit/dad654010a030f1038bd2df95a9647fb417e0447
	find pyu2f/tests -name '*.py' -exec \
		sed -e 's:assertEquals:assertEqual:' \
			-e 's:assertRaisesRegexp:assertRaisesRegex:' \
			-i {} + || die
	distutils-r1_python_prepare_all
}
