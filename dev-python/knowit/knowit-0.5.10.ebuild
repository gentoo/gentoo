# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Know better your media files"
HOMEPAGE="
	https://github.com/ratoaq2/knowit/
	https://pypi.org/project/knowit/
"
SRC_URI+="
	test? (
		https://downloads.sourceforge.net/matroska/test_files/matroska_test_w1_1.zip
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

# https://github.com/ratoaq2/knowit/blob/d7135a4797440838bca94e76326fc9d4019d8f9a/README.md?plain=1#L224
RDEPEND="
	>=dev-python/babelfish-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/enzyme-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/trakit-0.2.2[${PYTHON_USEDEP}]
	>=dev-python/pymediainfo-7.0.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
	|| (
		media-video/ffmpeg
		media-video/mediainfo
		media-video/mkvtoolnix
	)
"
BDEPEND="
	test? (
		app-arch/unzip
		>=dev-python/requests-2.32.4[${PYTHON_USEDEP}]
		media-video/ffmpeg
		media-video/mediainfo
		media-video/mkvtoolnix
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_unpack() {
	# Needed to unpack the test data
	default

	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	if use test ; then
		mkdir -p tests/data/videos || die
		ln -s "${WORKDIR}"/test*.mkv tests/data/videos/ || die
	fi

	distutils-r1_src_prepare

	# poetry, sigh
	sed -i -e 's:\^:>=:' pyproject.toml || die
}
