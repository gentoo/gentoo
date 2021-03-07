# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Python (ctypes) bindings for SDL2 libraries"
HOMEPAGE="https://github.com/marcusva/py-sdl2 https://pypi.org/project/PySDL2/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

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
		media-libs/sdl2-image
		media-libs/sdl2-mixer
		media-libs/sdl2-ttf
	)"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-nameerror.patch
)

src_prepare() {
	# tarball uses DOS line endings
	find '(' -name '*.py' -o -name '*.rst' -o -name '*.txt' ')' \
		-type f -exec sed -i -e 's/\r$//' {} + || die

	distutils-r1_src_prepare
}

src_test() {
	# from .travis.yml
	local -x SDL_VIDEODRIVER=dummy
	local -x SDL_AUDIODRIVER=dummy
	local -x SDL_RENDER_DRIVER=software

	distutils-r1_src_test
}
