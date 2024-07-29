# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE='threads(+)'
inherit distutils-r1 waf-utils

DESCRIPTION="Library for audio labelling"
HOMEPAGE="https://aubio.org/"
WAFVERSION=2.0.27
WAFTARBALL=waf-${WAFVERSION}.tar.bz2
SRC_URI="
	https://aubio.org/pub/${P}.tar.bz2
	https://waf.io/${WAFTARBALL}
"

LICENSE="GPL-3"
SLOT="0/5"
KEYWORDS="amd64 ~loong ~ppc ppc64 sparc x86"
IUSE="blas doc double-precision examples ffmpeg fftw jack libsamplerate sndfile python test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	?? ( double-precision libsamplerate )
	doc? ( python )
"

RESTRICT="!test? ( test )"

RDEPEND="
	blas? ( virtual/cblas )
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
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
BDEPEND="${DISTUTILS_DEPS}"

DOCS=( AUTHORS ChangeLog README.md )
PYTHON_SRC_DIR="${S}"

PATCHES=(
	"${FILESDIR}"/${P}-docdir.patch
	"${FILESDIR}"/${P}-gcc-14.patch
	"${FILESDIR}"/${P}-numpy-2.patch
	"${FILESDIR}"/ffmpeg5.patch
)

src_prepare() {
	default

	# In case when aubio is already installed, calling of the
	# `sphinx` function at the wscript causes a python interpreter
	# crash on `import aubio` if aubio was built with <numpy-2,
	# but current version of numpy is >=2.
	# Additionally, it causes duplication of the documentation.
	sed \
		-e '/\(doxygen\|sphinx\)(bld)$/d' \
		-e "s/package = 'blas'/package = 'cblas'/" \
		-i wscript || die

	sed -e "s/, 'sphinx.ext.intersphinx'//" -i doc/conf.py || die

	# ERROR: "Skipped: no test sounds, add some in 'python/tests/sounds/'!"
	rm python/tests/test_source.py || die

	if ! use test; then
		sed -e "/bld.*tests/d" -i wscript || die
	fi

	# update waf to fix Python 3.12 compatibility
	python_setup
	sed -r \
		-e "s:python:${PYTHON}:" \
		-e "s:(WAFVERSION=).*:\1${WAFVERSION}:" \
		-e "s:(WAFURL=).*:\1'${DISTDIR}/${WAFTARBALL}':" \
		-e 's:^fetchwaf$:cp "${WAFURL}" "${WAFTARBALL}":' \
		-i scripts/get_waf.sh || die
	emake expandwaf
}

src_configure() {
	python_setup

	local mywafconfargs=(
		--enable-complex
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable blas)
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
			# No API function available for this use case
			pushd "${S}"/doc &>/dev/null || die
			python_setup
			LD_LIBRARY_PATH="${S}/build/src:${LD_LIBRARY_PATH}" \
			PYTHONPATH="${S%%/}-${EPYTHON/./_}/install/usr/lib/${EPYTHON}/site-packages:${PYTHONPATH}" \
			emake html
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
		dodoc -r doc/_build/html/.
	fi

	find "${ED}" -name "*.a" -delete || die
}
