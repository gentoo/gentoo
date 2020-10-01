# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_6 python3_7 python3_8 )

inherit distutils-r1

MY_PV=${PV/_beta/b}
DESCRIPTION="Python Development Workflow for Humans"
HOMEPAGE="https://github.com/pypa/pipenv https://pypi.org/project/pipenv/"
SRC_URI="https://github.com/pypa/pipenv/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/pip-18.0[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-clone-0.2.5[${PYTHON_USEDEP}]
	"

BDEPEND="
	test? (
		${RDEPEND}
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		<dev-python/pytest-5[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)"

src_prepare() {
	# remove vendored version of PyYAML that is backported to Python2
	# this should be removed when upstream removes support for Python2
	rm -vR "${S}/${PN}/patched/yaml2/" || die
	# disable running of unittests in parallel with xdist
	sed -i 's/addopts = -ra -n auto/;&/g' setup.cfg
	sed -i 's/plugins = xdist/;&/g' setup.cfg
	distutils-r1_src_prepare
}

python_test() {
	pytest -vvv -x -m "not cli and not needs_internet" tests/unit/ || die
}
