# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Easy configuration as code tool for GitLab using config in plain YAML"
HOMEPAGE="https://github.com/egnyte/gitlabform"
SRC_URI="https://github.com/egnyte/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/pyyaml-3.13[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	sed -i -e "/pypandoc/d" -e "/long_description/d" setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	pytest -vv || die "Tests failed with ${EPYTHON}"
}
