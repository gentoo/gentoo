# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE='threads(+)'
inherit distutils-r1 waf-utils

DESCRIPTION="Library for audio labelling"
HOMEPAGE="https://aubio.org/"
SRC_URI="https://aubio.org/pub/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0/5"
KEYWORDS="amd64 ~ppc ppc64 sparc x86"
IUSE="doc double-precision examples ffmpeg fftw jack libsamplerate sndfile python test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	?? ( double-precision libsamplerate )
	doc? ( python )
"

RESTRICT="!test? ( test )"

RDEPEND="
	ffmpeg? ( >=media-video/ffmpeg-2.6:0= )
	fftw? ( sci-libs/fftw:3.0= )
	jack? ( virtual/jack )
	libsamplerate? ( media-libs/libsamplerate )
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	sndfile? ( media-libs/libsndfile )
"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-text/txt2man
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-python/sphinx
	)
"

DOCS=( AUTHORS ChangeLog README.md )
PYTHON_SRC_DIR="${S}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.9-docdir.patch
	"${FILESDIR}"/ffmpeg5.patch
	"${FILESDIR}"/${PN}-0.4.9-remove-universal-newlines.patch
)

src_prepare() {
	default

	sed -e "s:doxygen:doxygen_disabled:" -i wscript || die

	sed -e "s/, 'sphinx.ext.intersphinx'//" -i doc/conf.py || die

	# ERROR: "Skipped: no test sounds, add some in 'python/tests/sounds/'!"
	rm python/tests/test_source.py || die

	if ! use test; then
		sed -e "/bld.*tests/d" -i wscript || die
	fi
}

src_configure() {
	python_setup

	local mywafconfargs=(
		--enable-complex
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable doc docs)
		$(use_enable double-precision double)
		$(use_enable fftw fftw3)
		$(use_enable ffmpeg avcodec)
		$(use_enable jack)
		$(use_enable libsamplerate samplerate)
		$(use_enable sndfile)
	)

	use double-precision || mywafconfargs+=( $(use_enable fftw fftw3f) )

	waf-utils_src_configure "${mywafconfargs[@]}"

	if use python ; then
		cd "${PYTHON_SRC_DIR}" || die
		distutils-r1_src_configure
	fi
}

src_compile() {
	waf-utils_src_compile --notests

	if use python ; then
		cd "${PYTHON_SRC_DIR}" || die
		distutils-r1_src_compile

		if use doc ; then
			# No API function like distutils_install_for_testing available for this use case
			pushd "${S}"/doc &>/dev/null || die
			python_setup
			LD_LIBRARY_PATH="${S}/build/src:${LD_LIBRARY_PATH}" \
			PYTHONPATH="${S%%/}-${EPYTHON/./_}/lib${PYTHONPATH:+:${PYTHONPATH}}" \
			emake dirhtml
		fi

		cd "${S}" || die
	fi
}

src_test() {
	waf-utils_src_compile --alltests

	if use python ; then
		cd "${PYTHON_SRC_DIR}" || die
		distutils-r1_src_test
	fi
}

python_test() {
	 LD_LIBRARY_PATH="${S}/build/src:${LD_LIBRARY_PATH}" eunittest python/tests
}

src_install() {
	waf-utils_src_install

	if use examples; then
		# install dist_noinst_SCRIPTS from Makefile.am
		dodoc -r examples
	fi

	if use python ; then
		cd "${PYTHON_SRC_DIR}" || die
		DOCS="" distutils-r1_src_install
		newdoc python/README.md README.python
	fi

	if use doc; then
		dodoc doc/*.txt
		docinto html
		dodoc -r doc/_build/dirhtml/.
	fi

	find "${ED}" -name "*.a" -delete || die
}
