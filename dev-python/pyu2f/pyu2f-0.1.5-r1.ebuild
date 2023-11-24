# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python based U2F host library"
HOMEPAGE="https://github.com/google/pyu2f"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

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
	# adjust pyfakefs usage #888223
	sed -e "s:CreateFile:create_file:" \
		-e "s:CreateDirectory:create_dir:" \
		-e "s:RemoveObject:remove_object:" \
		-e "s:SetContents:set_contents:" \
		-i pyu2f/tests/hid/linux_test.py || die
	distutils-r1_python_prepare_all
}
