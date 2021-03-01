# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
PYTHON_REQ_USE='tk?,threads(+)'

inherit distutils-r1 toolchain-funcs virtualx

MY_PN=Pillow
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python Imaging Library (fork)"
HOMEPAGE="https://python-pillow.org/"
SRC_URI="https://github.com/python-pillow/Pillow/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="examples imagequant jpeg jpeg2k lcms test tiff tk truetype webp xcb zlib"
REQUIRED_USE="test? ( jpeg tiff )"
RESTRICT="!test? ( test )"

DEPEND="
	imagequant? ( media-gfx/libimagequant:0 )
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/openjpeg:2= )
	lcms? ( media-libs/lcms:2= )
	tiff? ( media-libs/tiff:0=[jpeg,zlib] )
	truetype? ( media-libs/freetype:2= )
	webp? ( media-libs/libwebp:0= )
	xcb? ( x11-libs/libxcb )
	zlib? ( sys-libs/zlib:0= )"
RDEPEND="${DEPEND}
	dev-python/olefile[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		media-gfx/imagemagick[png]
	)
"

python_configure_all() {
	# It's important that these flags are also passed during the install phase
	# as well. Make sure of that if you change the lines below. See bug 661308.
	mydistutilsargs=(
		build_ext
		--disable-platform-guessing
		$(use_enable truetype freetype)
		$(use_enable jpeg)
		$(use_enable jpeg2k jpeg2000)
		$(use_enable lcms)
		$(use_enable tiff)
		$(use_enable imagequant)
		$(use_enable webp)
		$(use_enable webp webpmux)
		$(use_enable xcb)
		$(use_enable zlib)
	)

	# setup.py sucks at adding the right toolchain paths but it does
	# accept additional ones from INCLUDE and LIB so set these. You
	# wouldn't normally need these at all as the toolchain should look
	# here anyway but this setup.py does stupid things.
	export \
		INCLUDE=${ESYSROOT}/usr/include \
		LIB=${ESYSROOT}/usr/$(get_libdir)

	# We have patched in this env var.
	tc-export PKG_CONFIG
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	"${EPYTHON}" selftest.py --installed || die "selftest failed with ${EPYTHON}"
	# no:relaxed: pytest-relaxed plugin make our tests fail. deactivate if installed
	pytest -vv -p no:relaxed || die "Tests fail with ${EPYTHON}"
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
