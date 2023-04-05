# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 virtualx xdg-utils

DESCRIPTION="Cross-platform windowing and multimedia library for Python"
HOMEPAGE="
	https://pyglet.org/
	https://github.com/pyglet/pyglet/
	https://pypi.org/project/pyglet/
"
SRC_URI="https://github.com/pyglet/pyglet/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86 ~amd64-linux ~x86-linux"
IUSE="examples image +sound"

BDEPEND="
	test? (
		dev-python/pillow[${PYTHON_USEDEP}]
		media-libs/fontconfig
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

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	xdg_environment_reset

	local EPYTEST_DESELECT=(
		# lacking device/server permissions
		tests/unit/media/test_listener.py::test_openal_listener
		tests/unit/media/test_listener.py::test_pulse_listener
		# fragile to system load
		tests/unit/media/test_player.py::PlayerTestCase::test_pause_resume
		tests/unit/test_clock_freq.py::test_elapsed_time_between_tick
	)
	if [[ ${EPYTHON} == python3.11 ]]; then
		EPYTEST_DESELECT+=(
			# broken test
			# https://github.com/pyglet/pyglet/issues/606
			tests/unit/test_events.py::test_push_handlers_instance
		)
	fi

	# Specify path to avoid running interactive tests
	# We could add in integration tests, but they're slow
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	nonfatal epytest tests/unit || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
