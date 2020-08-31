# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 virtualx xdg-utils

DESCRIPTION="Cross-platform windowing and multimedia library for Python"
HOMEPAGE="http://www.pyglet.org/"
SRC_URI="https://github.com/pyglet/pyglet/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="examples image +sound test"
RESTRICT="!test? ( test )"

RDEPEND="
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

BDEPEND="
	test? (
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

# pyglet.gl.glx_info.GLXInfoException: pyglet requires an X server with GLX
# Other tests fail or stall for unknown reasons.
RESTRICT=test

DOCS=(
	DESIGN
	NOTICE
	README.md
	RELEASE_NOTES
)

python_test() {
	xdg_environment_reset
	run_in_build_dir virtx pytest -v "${S}"/tests
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
