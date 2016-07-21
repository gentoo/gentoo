# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit cmake-utils toolchain-funcs eutils flag-o-matic

MY_P=${P/_/.}
DESCRIPTION="Luminance HDR is a graphical user interface that provides a workflow for HDR imaging"
HOMEPAGE="http://qtpfsgui.sourceforge.net"
SRC_URI="mirror://sourceforge/qtpfsgui/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
LANGS=" cs de es fi fr hi hu id it pl ro ru sk tr zh"
IUSE="cpu_flags_x86_sse2 ${LANGS// / linguas_} openmp"

DEPEND="
	>=media-gfx/exiv2-0.14
	media-libs/lcms:2
	media-libs/libpng
	>=media-libs/libraw-0.13.4
	>=media-libs/openexr-1.2.2-r2
	>=media-libs/tiff-3.8.2-r2
	sci-libs/fftw:3.0[threads]
	sci-libs/gsl
	virtual/jpeg
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4
	dev-qt/qtwebkit:4"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS BUGS Changelog README TODO )

S=${WORKDIR}/${MY_P}

pkg_pretend() {
	if use cpu_flags_x86_sse2 ; then
		append-flags -msse2
	else
		eerror "This package requires a CPU supporting the SSE2 instruction set."
		die "SSE2 support missing"
	fi

	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	# Don't try to define the git version of the release
	epatch "${FILESDIR}"/${PN}-2.3.0_beta1-no-git.patch

	# Don't install extra docs and fix install dir
	epatch "${FILESDIR}"/${PN}-2.2.1-docs.patch

	# Fix openmp automagic support
	epatch "${FILESDIR}"/${PN}-2.2.1-openmp-automagic.patch
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_use openmp OPENMP)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	for lang in ${LANGS} ; do
		if ! use linguas_${lang} ; then
			rm -f "${D}"/usr/share/${PN}/i18n/{lang,qt}_${lang}.qm || die
		fi
	done
}
