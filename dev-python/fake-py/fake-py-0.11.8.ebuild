# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=fake.py
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="Minimalistic, standalone alternative fake data generator with no dependencies"
HOMEPAGE="
	https://github.com/barseghyanartur/fake.py/
	https://pypi.org/project/fake-py/
"
# upstream removed examples (and their tests) from sdist around 0.11.8
SRC_URI="
	https://github.com/barseghyanartur/fake.py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# avoid pytest-codeblock which is another nightmare NIH package
	rm conftest.py || die
}

python_test() {
	# This package is a mess with tests thrown all over the place,
	# and they need to be run separately because of how messy this is.

	local EPYTEST_DESELECT=(
		# fails when started via 'python -m pytest' because of different
		# argparse output
		fake.py::TestCLI::test_no_command
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts= fake.py

	local suite
	for suite in customisation dataclasses hypothesis lazyfuzzy; do
		pushd "examples/${suite}" >/dev/null || die
		epytest -o addopts=
		popd >/dev/null || die
	done
}
