# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 toolchain-funcs

MY_P="libsass-python-${PV}"
DESCRIPTION="A straightforward binding of libsass for Python"
HOMEPAGE="https://github.com/sass/libsass-python/"
SRC_URI="
	https://github.com/sass/libsass-python/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-libs/libsass-3.6.5"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	test? (
		dev-python/PyQt5[testlib,${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
	)"

# Remove sassc, in favour of pysassc, see: https://github.com/sass/libsass-python/issues/134
# This avoids a file collision with dev-lang/sassc
PATCHES=( "${FILESDIR}"/libsass-0.20.0_rename_sassc.patch )

distutils_enable_tests pytest

src_prepare() {
	echo "${PV}" > .libsass-upstream-version || die
	distutils-r1_src_prepare
	export SYSTEM_SASS=1
	# https://bugs.gentoo.org/730244
	if tc-is-clang; then
		sed -i -e 's/-std=gnu++0x//g' setup.py || die
	fi
}

python_test() {
	local deselect=(
		# probably broken by removal of sassc
		sasstests.py::SasscTestCase::test_sassc_stdout
		# skip the pip tests because they need an internet connection
		# not relevant for gentoo anyway
		sasstests.py::DistutilsTestCase::test_build_sass
		sasstests.py::DistutilsTestCase::test_output_style
	)

	epytest sasstests.py ${deselect[@]/#/--deselect }
}
