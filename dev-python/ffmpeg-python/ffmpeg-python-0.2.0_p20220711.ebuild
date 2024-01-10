# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" == *_p20220711 ]] && COMMIT=df129c7ba30aaa9ffffb81a48f53aa7253b0b4e6
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python bindings for FFmpeg with complex filtering support"
HOMEPAGE="https://github.com/kkroening/ffmpeg-python/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/kkroening/${PN}.git"
else
	SRC_URI="https://github.com/kkroening/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	media-video/ffmpeg
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.2.0-no-future-795.patch"
)

EPYTEST_DESELECT=(
	ffmpeg/tests/test_ffmpeg.py::test__get_filter_complex_input
	ffmpeg/tests/test_ffmpeg.py::test__input__start_time
	ffmpeg/tests/test_ffmpeg.py::test__multi_output_edge_label_order
	ffmpeg/tests/test_ffmpeg.py::test__probe
	ffmpeg/tests/test_ffmpeg.py::test__probe__extra_args
	ffmpeg/tests/test_ffmpeg.py::test_fluent_complex_filter
	ffmpeg/tests/test_ffmpeg.py::test_pipe
	ffmpeg/tests/test_ffmpeg.py::test_repeated_args
)

distutils_enable_tests pytest
distutils_enable_sphinx doc/src
