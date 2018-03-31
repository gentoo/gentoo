# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PYTHON_REQ_USE='tk?,threads(+)'

inherit distutils-r1 eutils virtualx

MY_PN=Pillow
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python Imaging Library (fork)"
HOMEPAGE="https://python-pillow.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples imagequant jpeg2k lcms test tiff tk truetype webp zlib"

REQUIRED_USE="test? ( tiff )"

RDEPEND="
	dev-python/olefile[${PYTHON_USEDEP}]
	imagequant? ( media-gfx/libimagequant:0 )
	virtual/jpeg:0
	jpeg2k? ( media-libs/openjpeg:2= )
	lcms? ( media-libs/lcms:2= )
	tiff? ( media-libs/tiff:0=[jpeg] )
	truetype? ( media-libs/freetype:2= )
	webp? ( media-libs/libwebp:0= )
	zlib? ( sys-libs/zlib:0= )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
	test? (	dev-python/nose[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/${MY_P}"

src_compile() {
	# raqm not in portage yet
	distutils-r1_src_compile \
		--disable-raqm \
		$(use_enable truetype freetype) \
		$(use_enable jpeg2k jpeg2000) \
		$(use_enable lcms) \
		$(use_enable tiff) \
		$(use_enable imagequant) \
		$(use_enable webp) \
		$(use_enable webp webpmux) \
		$(use_enable zlib)
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" selftest.py --installed || die "selftest failed with ${EPYTHON}"
	virtx nosetests -vx Tests/test_*.py
}

python_install() {
	python_doheader libImaging/*.h
	distutils-r1_python_install
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	if use examples ; then
		docinto examples
		dodoc Scripts/*
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
