# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

BIN_COMMIT=224074bca448815e421a59266864c23041531a42
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
		https://github.com/imageio/imageio-binaries/raw/${BIN_COMMIT}/images/chelsea.png
			-> ${PN}-chelsea.png
		https://github.com/imageio/imageio-binaries/raw/${BIN_COMMIT}/images/cockatoo.mp4
			-> ${PN}-cockatoo.mp4
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# over 50% of tests rely on Internet
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	>=dev-python/numpy-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-8.3.2[${PYTHON_USEDEP}]
	media-libs/freeimage
"
# requests for fsspec[github]
BDEPEND="
	test? (
		dev-python/fsspec[${PYTHON_USEDEP}]
		dev-python/imageio-ffmpeg[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tifffile[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# block silently downloading vulnerable libraries from the Internet
		"${FILESDIR}"/imageio-2.22.0-block-download.patch
	)

	if use test; then
		mkdir -p "${HOME}"/.imageio/images || die
		local i
		for i in chelsea.png cockatoo.mp4; do
			cp "${DISTDIR}/${PN}-${i}" "${HOME}/.imageio/images/${i}" || die
		done
	fi

	distutils-r1_src_prepare
}

EPYTEST_DESELECT=(
	# Fails because of system installed freeimage
	tests/test_core.py::test_findlib2
	# Tries to download ffmpeg binary ?!
	tests/test_ffmpeg.py::test_get_exe_installed
	# blocked by our patch
	tests/test_core.py::test_fetching
	tests/test_core.py::test_request
	# removed upstream
	tests/test_pillow.py::test_png_remote
)
