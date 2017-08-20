# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit distutils-r1 waf-utils multilib eutils

DESCRIPTION="Library for audio labelling"
HOMEPAGE="http://aubio.org/"
SRC_URI="http://aubio.org//pub/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc double-precision examples ffmpeg fftw jack libav libsamplerate sndfile python"

RDEPEND="
	ffmpeg? (
		!libav? ( >=media-video/ffmpeg-2.6:0= )
		libav? ( >=media-video/libav-9:0= )
	)
	fftw? ( sci-libs/fftw:3.0 )
	jack? ( virtual/jack )
	libsamplerate? ( media-libs/libsamplerate )
	python? ( dev-python/numpy[${PYTHON_USEDEP}] ${PYTHON_DEPS} )
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	app-text/txt2man
	doc? ( app-doc/doxygen )"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DOCS=( AUTHORS ChangeLog README.md )
PYTHON_SRC_DIR="${S}/python"

src_prepare() {
	sed -i -e "s:doxygen:doxygen_disabled:" wscript || die
}

src_configure() {
	python_setup
	waf-utils_src_configure \
		--enable-complex \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_enable double-precision double) \
		$(use_enable fftw fftw3f) \
		$(use_enable fftw fftw3) \
		$(use_enable ffmpeg avcodec) \
		$(use_enable jack) \
		$(use_enable libsamplerate samplerate) \
		$(use_enable sndfile)

	if use python ; then
		cd "${PYTHON_SRC_DIR}" || die
		distutils-r1_src_configure
	fi
}

src_compile() {
	waf-utils_src_compile --notests

	if use doc; then
		cd "${S}"/doc || die
		doxygen full.cfg || die
	fi

	if use python ; then
		cd "${PYTHON_SRC_DIR}" || die
		distutils-r1_src_compile
	fi
}

src_test() {
	waf-utils_src_compile --alltests

	if use python ; then
		cd "${PYTHON_SRC_DIR}" || die
		distutils-r1_src_test
	fi
}

src_install() {
	waf-utils_src_install

	if use doc; then
		dohtml -r doc/full/html/.
		dodoc doc/*.txt
	fi

	if use examples; then
		# install dist_noinst_SCRIPTS from Makefile.am
		dodoc -r examples
	fi

	if use python ; then
		cd "${PYTHON_SRC_DIR}" || die
		DOCS="" distutils-r1_src_install
		newdoc README README.python
	fi
}
