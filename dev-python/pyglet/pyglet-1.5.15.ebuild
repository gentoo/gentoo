# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 virtualx xdg-utils

DESCRIPTION="Cross-platform windowing and multimedia library for Python"
HOMEPAGE="http://pyglet.org/"
SRC_URI="https://github.com/pyglet/pyglet/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples image +sound"

BDEPEND="
	test? (
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/gst-python[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	virtual/glu
	virtual/opengl
	image? ( || (
		dev-python/pillow[${PYTHON_USEDEP}]
		x11-libs/gtk+:2
	) )
	sound? ( || (
		media-libs/openal
		media-sound/pulseaudio
	) )
"
#	ffmpeg? ( media-libs/avbin-bin )

DOCS=( DESIGN NOTICE README.md RELEASE_NOTES )

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	xdg_environment_reset

	# Specify path to avoid running interactive tests
	# We could add in integration tests, but they're slow
	pytest -vv tests/unit || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
