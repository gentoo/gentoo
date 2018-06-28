# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Convert vector graphic file formats like .cdr, .svg, wmf and more."
HOMEPAGE="https://sk1project.net/modules.php?name=Products&product=uniconvertor"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

KEYWORDS="amd64 ~arm ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris ~x86-solaris"
SLOT="0"
LICENSE="GPL-2 LGPL-2"
IUSE=""

RDEPEND="
	dev-python/pycairo[${PYTHON_USEDEP}]
	media-gfx/imagemagick:=
	media-libs/lcms:2
	dev-python/pillow[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-text/ghostscript-gpl"

PATCHES=(
	"${FILESDIR}"/${P}-import.patch
	"${FILESDIR}"/${P}-libimg.patch
	"${FILESDIR}"/${P}-test.patch
	"${FILESDIR}"/${P}-abs.patch
	)

python_prepare_all() {
	local wand
	wand=$(pkg-config --libs MagickWand | sed -e "s:^ *::g" -e "s: *$::g" -e "s:-l:\':g" -e "s: :',:g" -e "s:$:':g" -e "s:,'$::g")

	distutils-r1_python_prepare_all

	sed \
		-e "s@/usr/include@${EPREFIX}/usr/include@" \
		-e "s@/usr/share@${EPREFIX}/usr/share@" \
		-e "/libraries/s:'MagickWand':${wand}:g" \
		-i setup.py || die

	# https://bugs.gentoo.org/581816
	if has_version ">=media-gfx/imagemagick-7.0" ; then
		sed  -e "s:ImageMagick-6:ImageMagick-7:" -i setup.py || die
		eapply "${FILESDIR}"/${P}-ImageMagick7.patch
	fi

	ln -sf \
		"${EPREFIX}"/usr/share/imagemagick/sRGB.icm \
		src/unittests/cms_tests/cms_data/sRGB.icm || die
}

python_test() {
	einfo ${PYTHONPATH}
	#distutils_install_for_testing
	cd src/unittests || die
	${EPYTHON} all_tests.py || die
}
