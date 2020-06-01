# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE='xml(+)'
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Python library to search and download subtitles"
HOMEPAGE="https://github.com/Diaoul/subliminal https://pypi.org/project/subliminal/"
SRC_URI="
	https://github.com/Diaoul/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? ( mirror://sourceforge/matroska/test_files/matroska_test_w1_1.zip )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/appdirs-1.3[${PYTHON_USEDEP}]
	>=dev-python/babelfish-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup-4.4.0:4[${PYTHON_USEDEP}]
	>=dev-python/chardet-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/click-4.0[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	>=dev-python/dogpile-cache-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/enzyme-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/guessit-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/pysrt-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/pytz-2012c[${PYTHON_USEDEP}]
	>=dev-python/rarfile-2.7[compressed,${PYTHON_USEDEP}]
	>=dev-python/requests-2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		app-arch/unzip
		dev-python/sympy[${PYTHON_USEDEP}]
		>=dev-python/vcrpy-1.6.1[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-fix-pytest-warning.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	# Disable code checkers as they require unavailable dependencies.
	sed -i -e 's/--\(pep8\|flakes\)//g' pytest.ini || die

	# Disable unconditional dependency on dev-python/pytest-runner.
	sed -i -e "s|'pytest-runner'||g" setup.py || die

	if use test; then
		mkdir -p tests/data/mkv || die
		ln -s "${WORKDIR}"/test*.mkv tests/data/mkv/ || die
	fi

	distutils-r1_python_prepare_all
}

python_test() {
	local skipped_tests=(
		tests/test_core.py::test_scan_archive_with_one_video
		tests/test_core.py::test_scan_archive_with_multiple_videos
		tests/test_core.py::test_scan_archive_with_no_video
		tests/test_core.py::test_scan_password_protected_archive
	)

	# Two tests that list providers rely on entry points
	# so they need the package to be installed
	distutils_install_for_testing
	pytest -vv --ignore ${PN}/test/test_core.py ${skipped_tests[@]/#/--deselect } \
		|| die "Tests fail with ${EPYTHON}"
}
