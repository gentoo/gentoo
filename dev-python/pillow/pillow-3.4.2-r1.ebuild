# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )
PYTHON_REQ_USE='tk?,threads(+)'

inherit distutils-r1 eutils virtualx

MY_PN=Pillow
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python Imaging Library (fork)"
HOMEPAGE="https://github.com/python-imaging/Pillow https://pypi.org/project/Pillow/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="HPND"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="doc examples jpeg jpeg2k lcms test tiff tk truetype webp zlib"

REQUIRED_USE="test? ( jpeg tiff )"

RDEPEND="
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/openjpeg:2= )
	lcms? ( media-libs/lcms:2= )
	tiff? ( media-libs/tiff:0= )
	truetype? ( media-libs/freetype:2= )
	webp? ( media-libs/libwebp:0= )
	zlib? ( sys-libs/zlib:0= )"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-better-theme[${PYTHON_USEDEP}]
		>=dev-python/sphinx_rtd_theme-0.1[${PYTHON_USEDEP}]
		<dev-python/sphinx_rtd_theme-0.2[${PYTHON_USEDEP}]
	)
	test? (	dev-python/nose[${PYTHON_USEDEP}] )
	"

S="${WORKDIR}/${MY_P}"

# See _render and _clean in Tests/test_imagefont.py
DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}/pillow-3.4.2-no-scripts.patch"
)

python_prepare_all() {
	# Disable all the stuff we don't want.
	local f
	for f in jpeg lcms tiff tk webp zlib; do
		if ! use ${f}; then
			sed -i -e "s:feature.${f} =:& None #:" setup.py || die
		fi
	done
	if ! use truetype; then
		sed -i -e 's:feature.freetype =:& None #:' setup.py || die
	fi
	if ! use jpeg2k; then
		sed -i -e 's:feature.jpeg2000 =:& None #:' setup.py || die
	fi

	sed \
		-e "/required/s:=.*:= set():g" \
		-e "/if f in/s:'jpeg', 'libz'::g" \
		-i setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" selftest.py --installed || die "selftest failed with ${EPYTHON}"
	virtx nosetests -vx Tests/test_*.py
}

python_install() {
	python_doheader libImaging/{Imaging.h,ImPlatform.h}

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
