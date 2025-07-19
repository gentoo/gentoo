# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
# setuptools wrapper
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
PYTHON_REQ_USE='tk?,threads(+)'

inherit distutils-r1 toolchain-funcs virtualx

MY_PN=Pillow
MY_P=${MY_PN}-${PV}

# upstream always fetches from main
TEST_IMAGE_COMMIT="7077675d2cda485d63de4aefe0fefbf6f655c5a0"

DESCRIPTION="Python Imaging Library (fork)"
HOMEPAGE="
	https://python-pillow.org/
	https://github.com/python-pillow/Pillow/
	https://pypi.org/project/pillow/
"
SRC_URI="
	https://github.com/python-pillow/Pillow/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://github.com/python-pillow/test-images/archive/${TEST_IMAGE_COMMIT}.tar.gz
			-> pillow-test-images-${TEST_IMAGE_COMMIT}.gh.tar.gz
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="HPND"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="avif examples imagequant +jpeg jpeg2k lcms test tiff tk truetype webp xcb zlib"
REQUIRED_USE="test? ( jpeg jpeg2k lcms tiff truetype )"
RESTRICT="!test? ( test )"

DEPEND="
	avif? ( media-libs/libavif:= )
	imagequant? ( media-gfx/libimagequant:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	jpeg2k? ( media-libs/openjpeg:2= )
	lcms? ( media-libs/lcms:2= )
	tiff? ( media-libs/tiff:=[jpeg,zlib] )
	truetype? (
		media-libs/freetype:2=
		media-libs/harfbuzz:=
	)
	webp? ( media-libs/libwebp:= )
	xcb? ( x11-libs/libxcb )
	zlib? ( sys-libs/zlib:= )
"
RDEPEND="
	${DEPEND}
	dev-python/olefile[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-77[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	virtual/pkgconfig
	test? (
		dev-python/defusedxml[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		|| (
			media-gfx/imagemagick[png]
			media-gfx/graphicsmagick[png]
		)
	)
"

EPYTEST_PLUGINS=( pytest-timeout )
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# https://github.com/python-pillow/pillow/pull/7634
		"${FILESDIR}/${PN}-10.2.0-cross.patch"
	)

	distutils-r1_src_prepare

	if use test; then
		mv "${WORKDIR}/test-images-${TEST_IMAGE_COMMIT}"/* \
			Tests/images || die
	fi
}

usepil() {
	usex "${1}" enable disable
}

python_configure_all() {
	cat >> setup.cfg <<-EOF || die
		[build_ext]
		debug = True
		disable_platform_guessing = True
		$(usepil avif)_avif = True
		$(usepil truetype)_freetype = True
		$(usepil jpeg)_jpeg = True
		$(usepil jpeg2k)_jpeg2000 = True
		$(usepil lcms)_lcms = True
		$(usepil tiff)_tiff = True
		$(usepil imagequant)_imagequant = True
		$(usepil webp)_webp = True
		$(usepil xcb)_xcb = True
		$(usepil zlib)_zlib = True
	EOF
	if use truetype; then
		# these dependencies are implicitly disabled by USE=-truetype
		# and we can't pass both disable_* and vendor_*
		# https://bugs.gentoo.org/935124
		cat >> setup.cfg <<-EOF || die
			vendor_raqm = False
			vendor_fribidi = False
		EOF
	fi

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

	case ${ARCH} in
		ppc)
			EPYTEST_DESELECT+=(
				# https://github.com/python-pillow/Pillow/issues/7008
				# (we've reverted the upstream patch because it was worse
				# than the original issue)
				Tests/test_file_libtiff.py::TestFileLibTiff::test_exif_ifd
			)
			;;
	esac

	"${EPYTHON}" selftest.py --installed || die "selftest failed with ${EPYTHON}"
	# leak tests are fragile and broken under xdist
	# nonfatal implied by xvfb
	nonfatal epytest -k "not leak" || die "Tests failed with ${EPYTHON}"
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
