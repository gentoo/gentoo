# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE='xml(+)'

inherit distutils-r1

DESCRIPTION="Python library to search and download subtitles"
HOMEPAGE="https://github.com/Diaoul/subliminal https://pypi.org/project/subliminal/"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Diaoul/${PN}.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/Diaoul/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

SRC_URI+=" test? ( https://downloads.sourceforge.net/matroska/test_files/matroska_test_w1_1.zip )"

LICENSE="MIT"
SLOT="0"

BDEPEND="
	test? (
		app-arch/unzip
		dev-python/sympy[${PYTHON_USEDEP}]
		>=dev-python/vcrpy-1.6.1[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/babelfish-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup4-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/chardet-5.0[${PYTHON_USEDEP}]
	>=dev-python/click-8.0[${PYTHON_USEDEP}]
	>=dev-python/click-option-group-0.5.6[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	>=dev-python/dogpile-cache-1.0[${PYTHON_USEDEP}]
	>=dev-python/enzyme-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/guessit-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-4.2[${PYTHON_USEDEP}]
	>=dev-python/pysubs2-1.7[${PYTHON_USEDEP}]
	>=dev-python/rarfile-2.7[compressed,${PYTHON_USEDEP}]
	>=dev-python/requests-2.0[${PYTHON_USEDEP}]
	>=dev-python/srt-3.5[${PYTHON_USEDEP}]
	>=dev-python/stevedore-3.0[${PYTHON_USEDEP}]
	>=dev-python/tomli-2[${PYTHON_USEDEP}]
"

EPYTEST_DESELECT=(
	# Needs network
	tests/test_core.py::test_scan_archive_with_one_video
	tests/test_core.py::test_scan_archive_with_multiple_videos
	tests/test_core.py::test_scan_archive_with_no_video
	tests/test_core.py::test_scan_password_protected_archive

	# TODO
	tests/test_core.py::test_refine_video_metadata
)

distutils_enable_tests pytest

src_unpack() {
	# Needed to unpack the test data
	default

	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	fi
}

python_prepare_all() {
	if use test ; then
		mkdir -p tests/data/mkv || die
		ln -s "${WORKDIR}"/test*.mkv tests/data/mkv/ || die
	fi

	distutils-r1_python_prepare_all
}
