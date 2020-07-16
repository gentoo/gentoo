# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE='xml(+)'
COMMIT_ID='dd74383d1cba82829ce720f2e439a65d13ffe7ef'

inherit distutils-r1

DESCRIPTION="Python library to search and download subtitles"
HOMEPAGE="https://github.com/Diaoul/subliminal https://pypi.org/project/subliminal/"
SRC_URI="
	https://github.com/Diaoul/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}-r2.tar.gz
	test? ( mirror://sourceforge/matroska/test_files/matroska_test_w1_1.zip )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

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
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.0.0[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		app-arch/unzip
		dev-python/sympy[${PYTHON_USEDEP}]
		>=dev-python/vcrpy-1.6.1[${PYTHON_USEDEP}]
	)
"

# Tests don't work in 2.0.5. Recheck in later versions. See Gentoo bug 630114.
RESTRICT=test

PATCHES=( "${FILESDIR}/${P}-add-missing-comma.patch" )

S="${WORKDIR}/${PN}-${COMMIT_ID}"

distutils_enable_tests pytest

python_prepare_all() {
	# Disable code checkers as they require unavailable dependencies.
	sed -i -e 's/--\(pep8\|flakes\)//g' pytest.ini || die
	sed -i -e "s/'pytest-\(pep8\|flakes\)',//g" setup.py || die

	# Disable unconditional dependency on dev-python/pytest-runner.
	sed -i -e "s|'pytest-runner'||g" setup.py || die

	if use test; then
		mkdir -p tests/data/mkv || die
		ln -s "${WORKDIR}"/test*.mkv tests/data/mkv/ || die
	fi

	distutils-r1_python_prepare_all
}
