# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

PYTHON_DEPEND="2:2.6"

inherit autotools eutils python

DESCRIPTION="Library for audio labelling"
HOMEPAGE="http://aubio.piem.org"
SRC_URI="http://aubio.piem.org/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 sparc x86"
IUSE="alsa doc examples jack lash static-libs"

RDEPEND="sci-libs/fftw:3.0
	media-libs/libsndfile
	media-libs/libsamplerate
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	lash? ( media-sound/lash )"
DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.0
	virtual/pkgconfig
	doc? ( app-doc/doxygen virtual/latex-base )"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog README TODO )

	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# disable automagic puredata wrt #369835
	sed -i -e '/AC_CHECK_HEADER/s:m_pd.h:dIsAbLe&:' configure.ac || die

	epatch \
		"${FILESDIR}"/${P}-multilib.patch \
		"${FILESDIR}"/${P}-numarray-gnuplot.patch

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable jack) \
		$(use_enable alsa) \
		$(use_enable lash)
}

src_compile() {
	default

	if use doc; then
		export VARTEXFONTS="${T}/fonts"
		cd "${S}"/doc
		doxygen user.cfg
		doxygen devel.cfg
		doxygen examples.cfg
	fi
}

src_install() {
	# `default` would be enough here if python.eclass supported EAPI=4
	emake DESTDIR="${D}" install || die
	dodoc "${DOCS[@]}"

	doman doc/*.1
	if use doc; then
		mv doc/user/html doc/user/user
		dohtml -r doc/user/user
		mv doc/devel/html doc/devel/devel
		dohtml -r doc/devel/devel
		mv doc/examples/html doc/examples/examples
		dohtml -r doc/examples/examples
	fi

	if use examples; then
		# install dist_noinst_SCRIPTS from Makefile.am
		insinto /usr/share/doc/${PF}/examples
		doins python/aubio{compare-onset,plot-notes,filter-notes,web.py} || die
		docinto examples
		newdoc python/README README.examples
	fi

	find "${ED}"usr -name '*.la' -exec rm -f {} +
}

pkg_postinst() { python_mod_optimize aubio; }
pkg_postrm() { python_mod_cleanup aubio; }
