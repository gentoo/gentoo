# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Know better your media files"
HOMEPAGE="
	https://github.com/ratoaq2/knowit
	https://pypi.org/project/knowit/
"
# No tests in sdist
SRC_URI="https://github.com/ratoaq2/knowit/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
SRC_URI+=" test? ( https://downloads.sourceforge.net/matroska/test_files/matroska_test_w1_1.zip )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

# https://github.com/ratoaq2/knowit/blob/d7135a4797440838bca94e76326fc9d4019d8f9a/README.md?plain=1#L224
RDEPEND="
	dev-python/babelfish[${PYTHON_USEDEP}]
	dev-python/enzyme[${PYTHON_USEDEP}]
	dev-python/trakit[${PYTHON_USEDEP}]
	dev-python/pymediainfo[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	|| (
		media-video/ffmpeg
		media-video/mediainfo
		media-video/mkvtoolnix
	)
"
BDEPEND="
	test? (
		app-arch/unzip
		dev-python/requests[${PYTHON_USEDEP}]
		media-video/ffmpeg
		media-video/mediainfo
		media-video/mkvtoolnix
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.6-no-pint.patch
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
		mkdir -p tests/data/videos || die
		ln -s "${WORKDIR}"/test*.mkv tests/data/videos/ || die
	fi

	distutils-r1_python_prepare_all
}
