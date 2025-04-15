# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi unpacker

DESCRIPTION="Python package for natural language processing."
HOMEPAGE="
	https://www.nltk.org/
	https://github.com/nltk/nltk/
	https://pypi.org/project/nltk/
"

NLTK_DATA_COMMIT="66f9f16b4eeff469470038e1aa82a1a1651e198a"
SRC_URI="
	mirror+$(pypi_sdist_url)
	test? (
		https://github.com/nltk/nltk_data/archive/${NLTK_DATA_COMMIT}.tar.gz
			-> ntltk_data-${NLTK_DATA_COMMIT}.tar.gz
	)
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# licenses of the test data is complicated.
# Mix of public comain, explicit permission to distribute and creative commons.
# To be safe disable mirroring for that
# https://github.com/nltk/nltk_data/blob/gh-pages/index.xml
RESTRICT="mirror"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	>=dev-python/regex-2021.8.3[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"

# unpacker.eclass doesn't handle use flags, so manually add the dependency
BDEPEND="
	test? (
		app-arch/unzip
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# network-sandbox
	nltk/test/unit/test_downloader.py::test_downloader_using_existing_parent_download_dir
	nltk/test/unit/test_downloader.py::test_downloader_using_non_existing_parent_download_dir
)

src_unpack() {
	default

	if use test; then
		# https://www.nltk.org/data.html#manual-installation
		# https://github.com/nltk/nltk_data
		mkdir -p "${HOME}"/nltk_data/{chunkers,grammars,misc,sentiment,taggers,corpora} || die
		mkdir -p "${HOME}"/nltk_data/{help,models,stemmers,tokenizers} || die

		for file in $(find nltk_data-${NLTK_DATA_COMMIT}/packages -name "*.zip"); do
			local file_no_zip
			unpack_zip "${file}"
			file_dir="${file##nltk_data-${NLTK_DATA_COMMIT}/packages}"
			file_dir="${file_dir%%.zip}"
			mv "${file_dir##*/}" "${HOME}"/nltk_data/"${file_dir}" || die
		done
	fi
}
