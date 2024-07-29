# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python (ctypes) bindings for SDL2 libraries"
HOMEPAGE="
	https://github.com/py-sdl/py-sdl2/
	https://pypi.org/project/PySDL2/
"

LICENSE="|| ( public-domain CC0-1.0 ZLIB )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Optional deps:
# - dev-python/numpy,
# - dev-python/pillow,
# - media-libs/sdl2-* (loaded dynamically via ctypes).
#
# If a reverse dependency needs the specific module, it should
# explicitly depend on the optional module in question. You also
# probably need to explicitly require some media-libs/libsdl2 flags.
RDEPEND="media-libs/libsdl2"

# Require all of SDL2 libraries and at least the most common subsystems
# for better test coverage.
DEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		media-libs/libsdl2[joystick,sound,video]
		media-libs/sdl2-gfx
		media-libs/sdl2-image[gif,jpeg,png,tiff,webp]
		|| (
			media-libs/sdl2-mixer[flac]
			media-libs/sdl2-mixer[midi]
			media-libs/sdl2-mixer[mod]
			media-libs/sdl2-mixer[mp3]
			media-libs/sdl2-mixer[opus]
		)
		media-libs/sdl2-ttf
	)"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# pysdl2 was misusing libsdl2's error API. Fixed upstream already
		# but it didn't land in 0.9.16.
		# https://bugs.gentoo.org/916120
		# https://bugs.gentoo.org/916118
		sdl2/test/gamecontroller_test.py
		sdl2/test/hidapi_test.py::test_SDL_hid_enumerate
	)

	local -x SDL_VIDEODRIVER=dummy
	local -x SDL_AUDIODRIVER=dummy
	local -x SDL_RENDER_DRIVER=software

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -x
}
