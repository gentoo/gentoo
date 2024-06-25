# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
# setuptools wrapper
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{10..13} pypy3 )
PYTHON_REQ_USE='tk?,threads(+)'

inherit distutils-r1 toolchain-funcs virtualx

MY_PN=Pillow
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python Imaging Library (fork)"
HOMEPAGE="
	https://python-pillow.org/
	https://github.com/python-pillow/Pillow/
	https://pypi.org/project/pillow/
"
SRC_URI="
	https://github.com/python-pillow/Pillow/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="examples imagequant +jpeg jpeg2k lcms test tiff tk truetype webp xcb zlib"
REQUIRED_USE="test? ( jpeg jpeg2k lcms tiff truetype )"
RESTRICT="!test? ( test )"

DEPEND="
	imagequant? ( media-gfx/libimagequant:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	jpeg2k? ( media-libs/openjpeg:2= )
	lcms? ( media-libs/lcms:2= )
	tiff? ( media-libs/tiff:=[jpeg,zlib] )
	truetype? ( media-libs/freetype:2= )
	webp? ( media-libs/libwebp:= )
	xcb? ( x11-libs/libxcb )
	zlib? ( sys-libs/zlib:= )
"
RDEPEND="
	${DEPEND}
	dev-python/olefile[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	virtual/pkgconfig
	test? (
		dev-python/defusedxml[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		|| (
			media-gfx/imagemagick[png]
			media-gfx/graphicsmagick[png]
		)
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/python-pillow/pillow/pull/7634
	"${FILESDIR}/${PN}-10.2.0-cross.patch"
	# https://github.com/python-pillow/Pillow/pull/8050
	"${FILESDIR}/${P}-py313.patch"
)

usepil() {
	usex "${1}" enable disable
}

python_configure_all() {
	# It's important that these flags are also passed during the install phase
	# as well. Make sure of that if you change the lines below. See bug 661308.
	cat >> setup.cfg <<-EOF || die
		[build_ext]
		disable_platform_guessing = True
		$(usepil truetype)_freetype = True
		$(usepil jpeg)_jpeg = True
		$(usepil jpeg2k)_jpeg2000 = True
		$(usepil lcms)_lcms = True
		$(usepil tiff)_tiff = True
		$(usepil imagequant)_imagequant = True
		$(usepil webp)_webp = True
		$(usepil webp)_webpmux = True
		$(usepil xcb)_xcb = True
		$(usepil zlib)_zlib = True
	EOF

	# We have patched in this env var.
	tc-export PKG_CONFIG
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO (is clipboard unreliable in Xvfb?)
		Tests/test_imagegrab.py::TestImageGrab::test_grabclipboard
		# requires xz-utils[extra-filters]?
		Tests/test_file_libtiff.py::TestFileLibTiff::test_lzma
	)

	"${EPYTHON}" selftest.py --installed || die "selftest failed with ${EPYTHON}"
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# leak tests are fragile and broken under xdist
	epytest -k "not leak" -p timeout || die "Tests failed with ${EPYTHON}"
}

python_install() {
	python_doheader src/libImaging/*.h
	distutils-r1_python_install
}

python_install_all() {
	if use examples ; then
		docinto example
		dodoc docs/example/*
		docompress -x /usr/share/doc/${PF}/example
	fi
	distutils-r1_python_install_all
}
