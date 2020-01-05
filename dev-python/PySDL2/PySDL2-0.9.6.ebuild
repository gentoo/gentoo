# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{6,7}} )
inherit distutils-r1

DESCRIPTION="Python (ctypes) bindings for SDL2 libraries"
HOMEPAGE="https://github.com/marcusva/py-sdl2 https://pypi.org/project/PySDL2/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="|| ( public-domain CC0-1.0 ZLIB )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

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

PATCHES=(
	# fix tests to allow newer versions of libsdl2
	"${FILESDIR}"/PySDL2-0.9.6-0001-test-Always-allow-greater-patch-version-of-SDL2.patch
	# fix tests to handle missing haptic support gracefully
	"${FILESDIR}"/PySDL2-0.9.6-0002-test-Handle-missing-haptic-support-gracefully.patch
)

src_prepare() {
	# tarball uses DOS line endings
	find '(' -name '*.py' -o -name '*.rst' -o -name '*.txt' ')' \
		-type f -exec sed -i -e 's/\r$//' {} + || die

	distutils-r1_src_prepare
}

python_test() {
	# from .travis.yml
	local -x SDL_VIDEODRIVER=dummy
	local -x SDL_AUDIODRIVER=dummy
	local -x SDL_RENDER_DRIVER=software

	"${PYTHON}" -m unittest discover -v \
		-s sdl2/test -p '*_test.py' || die "Tests fail with ${EPYTHON}"
}
