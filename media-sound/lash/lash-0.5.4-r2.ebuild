# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/lash/lash-0.5.4-r2.ebuild,v 1.9 2014/11/02 09:03:38 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils multilib-minimal python-single-r1

DESCRIPTION="LASH Audio Session Handler"
HOMEPAGE="http://www.nongnu.org/lash/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE="alsa debug gtk python static-libs" # doc

RDEPEND="dev-libs/libxml2
	media-sound/jack-audio-connection-kit
	>=sys-apps/util-linux-2.24.1-r3[${MULTILIB_USEDEP}]
	alsa? ( media-libs/alsa-lib )
	gtk? ( x11-libs/gtk+:2 )
	python? ( ${PYTHON_DEPS} )
	|| ( sys-libs/readline dev-libs/libedit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? ( >=dev-lang/swig-1.3.40 )"
# doc? ( >=app-text/texi2html-5 )

DOCS="AUTHORS ChangeLog NEWS README TODO"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	sed -i \
		-e '/texi2html/s:-number:&-sections:' \
		docs/Makefile.am || die #422045

	epatch \
		"${FILESDIR}"/${P}-glibc2.8.patch \
		"${FILESDIR}"/${P}-swig_version_comparison.patch \
		"${FILESDIR}"/${P}-gcc47.patch \
		"${FILESDIR}"/${P}-underlinking.patch \
		"${FILESDIR}"/${P}-strcmp.patch

	AT_M4DIR=m4 eautoreconf
}

multilib_src_configure() {
	# 'no' could be '$(usex doc)' but we use the pregenerated lash-manual.html
	export ac_cv_prog_lash_texi2html=no #422045

	# --enable-pylash would disable it
	local myconf=()
	if ! multilib_is_native_abi || ! use python; then
		myconf+=( --disable-pylash )
	fi

	if ! multilib_is_native_abi; then
		# disable remaining configure checks
		myconf+=(
			JACK_CFLAGS=' '
			JACK_LIBS=' '
			XML2_CFLAGS=' '
			XML2_LIBS=' '

			vl_cv_lib_readline=no
		)
	fi

	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		$(multilib_native_use_enable alsa alsa-midi) \
		$(multilib_native_use_enable gtk gtk2) \
		$(multilib_native_use_enable debug) \
		"${myconf[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default
	else
		emake -C liblash
	fi
}

multilib_src_test() {
	multilib_is_native_abi && default
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" install
	else
		# headers
		emake -C lash DESTDIR="${D}" install
		# library
		emake -C liblash DESTDIR="${D}" install
		# pkg-config
		emake DESTDIR="${D}" install-pkgconfigDATA
	fi
}

multilib_src_install_all() {
	dohtml docs/lash-manual-html-*/lash-manual.html
	prune_libtool_files --all # --all for _lash.la in python directory
	use python && python_optimize
}
