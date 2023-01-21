# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="A straightforward binding of libsass for Python"
HOMEPAGE="
	https://github.com/sass/libsass-python/
	https://pypi.org/project/libsass/
"
SRC_URI="
	https://github.com/sass/libsass-python/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 x86"

DEPEND="
	>=dev-libs/libsass-3.6.5
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		dev-python/PyQt5[testlib,${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	echo "${PV}" > .libsass-upstream-version || die
	distutils-r1_src_prepare
	export SYSTEM_SASS=1
	# https://bugs.gentoo.org/881339
	# the package is applying C++ flags to C sources
	sed -i -e "s:'-std=gnu++0x',::" -e "s:'-lstdc++'::" setup.py || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# probably broken by removal of sassc
		sasstests.py::SasscTestCase::test_sassc_stdout
		# skip the pip tests because they need an internet connection
		# not relevant for gentoo anyway
		sasstests.py::DistutilsTestCase::test_build_sass
		sasstests.py::DistutilsTestCase::test_output_style
	)

	epytest sasstests.py
}
