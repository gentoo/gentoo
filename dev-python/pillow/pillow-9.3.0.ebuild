# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )
PYTHON_REQ_USE='tk?,threads(+)'

inherit distutils-r1 toolchain-funcs virtualx

MY_PN=Pillow
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python Imaging Library (fork)"
HOMEPAGE="
	https://python-pillow.org/
	https://github.com/python-pillow/
	https://pypi.org/project/Pillow/
"
SRC_URI="
	https://github.com/python-pillow/Pillow/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="examples imagequant +jpeg jpeg2k lcms test tiff tk truetype webp xcb zlib"
REQUIRED_USE="test? ( jpeg jpeg2k tiff truetype )"
RESTRICT="!test? ( test )"

DEPEND="
	imagequant? ( media-gfx/libimagequant:0 )
	jpeg? ( media-libs/libjpeg-turbo )
	jpeg2k? ( media-libs/openjpeg:2= )
	lcms? ( media-libs/lcms:2= )
	tiff? ( media-libs/tiff:0=[jpeg,zlib] )
	truetype? ( media-libs/freetype:2= )
	webp? ( media-libs/libwebp:0= )
	xcb? ( x11-libs/libxcb )
	zlib? ( sys-libs/zlib:0= )
"
RDEPEND="
	${DEPEND}
	dev-python/olefile[${PYTHON_USEDEP}]
"
BDEPEND="
	virtual/pkgconfig
	test? (
		${RDEPEND}
		dev-python/defusedxml[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		|| (
			media-gfx/imagemagick[png]
			media-gfx/graphicsmagick[png]
		)
	)
"

EPYTEST_DESELECT=(
	# TODO; incompatible Qt version?
	Tests/test_qt_image_qapplication.py::test_sanity
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

	# setup.py won't let us add the right toolchain paths but it does
	# accept additional ones from INCLUDE and LIB so set these. You
	# wouldn't normally need these at all as the toolchain should look
	# here anyway but it doesn't for this setup.py.
	export \
		INCLUDE="${ESYSROOT}"/usr/include \
		LIB="${ESYSROOT}"/usr/$(get_libdir)

	# We have patched in this env var.
	tc-export PKG_CONFIG
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	"${EPYTHON}" selftest.py --installed || die "selftest failed with ${EPYTHON}"
	# no:relaxed: pytest-relaxed plugin make our tests fail. deactivate if installed
	epytest -p no:relaxed || die "Tests failed with ${EPYTHON}"
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
