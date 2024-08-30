# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

TEST_IMAGES_COMMIT=1121036015c70cdbb3015e5c5ba0aaaf7d3d6021
DESCRIPTION="Python library for reading and writing image data"
HOMEPAGE="
	https://imageio.readthedocs.io/en/stable/
	https://github.com/imageio/imageio/
	https://pypi.org/project/imageio/
"
SRC_URI="
	https://github.com/imageio/imageio/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://github.com/imageio/test_images/archive/${TEST_IMAGES_COMMIT}.tar.gz
			-> imageio-test_images-${TEST_IMAGES_COMMIT}.gh.tar.gz
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/numpy-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-8.3.2[${PYTHON_USEDEP}]
	media-libs/freeimage
"
BDEPEND="
	test? (
		>=dev-python/imageio-ffmpeg-0.4.9-r1[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/tifffile[${PYTHON_USEDEP}]
		|| (
			media-video/ffmpeg[openh264]
			media-video/ffmpeg[x264]
		)
	)
"

distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# block silently downloading vulnerable libraries from the Internet
		"${FILESDIR}/imageio-2.22.0-block-download.patch"
	)

	if use test; then
		mv "${WORKDIR}/test_images-${TEST_IMAGES_COMMIT}" .test_images || die
		# upstream tries to update the image cache, and invalidates it
		# if "git pull" fails
		sed -i -e 's:git pull:true:' tests/conftest.py || die
		# ffmpeg tests expect it there
		mkdir -p "${HOME}/.imageio/images" || die
		cp .test_images/cockatoo.mp4 "${HOME}/.imageio/images" || die
	fi

	distutils-r1_src_prepare

	# unpin numpy
	sed -i -e '/numpy/s:<2.0.0::' setup.py || die
}

python_test() {
	local EPYTEST_IGNORE=(
		# uses fsspec to grab prebuilt .so from GitHub, sigh
		tests/test_freeimage.py
	)

	local EPYTEST_DESELECT=(
		# Note: upstream has a needs_internet marker but it is also
		# used to mark tests that require test_images checkout that we
		# supply

		# Tries to download ffmpeg binary ?!
		tests/test_ffmpeg.py::test_get_exe_installed
		# blocked by our patch
		tests/test_core.py::test_fetching
		tests/test_core.py::test_request
		# Internet
		tests/test_bsdf.py::test_from_url
		tests/test_core.py::test_mvolread_out_of_bytes
		tests/test_core.py::test_request_read_sources
		tests/test_pillow.py::test_gif_first_p_frame
		tests/test_pillow.py::test_png_remote
		tests/test_pillow.py::test_webp_remote
		tests/test_pillow_legacy.py::test_png_remote
		tests/test_swf.py::test_read_from_url
		# requires pillow-heif, also possibly Internet
		tests/test_pillow.py::test_avif_remote
		tests/test_pillow.py::test_heif_remote
		# not important, requires random system libs
		tests/test_core.py::test_findlib2
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
