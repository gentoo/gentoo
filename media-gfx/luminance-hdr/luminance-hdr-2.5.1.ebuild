# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils toolchain-funcs eutils flag-o-matic

MY_P=${P/_/.}
DESCRIPTION="Graphical user interface that provides a workflow for HDR imaging"
HOMEPAGE="http://qtpfsgui.sourceforge.net https://github.com/LuminanceHDR/LuminanceHDR"
SRC_URI="mirror://sourceforge/qtpfsgui/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LANGS=" cs de es fi fr hi hu id it pl ro ru sk tr zh"
IUSE="cpu_flags_x86_sse2 fits openmp test ${LANGS// / l10n_}"

RDEPEND="
	dev-libs/boost:0=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtwebengine:5
	>=media-gfx/exiv2-0.14:0=
	media-libs/lcms:2
	media-libs/libpng:0=
	>=media-libs/libraw-0.13.4:=
	media-libs/ilmbase:=
	>=media-libs/openexr-1.2.2-r2:=
	>=media-libs/tiff-3.8.2-r2:0
	sci-libs/fftw:3.0[threads]
	fits? ( sci-libs/cfitsio )
	sci-libs/gsl
	virtual/jpeg:0
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	test? ( dev-cpp/gtest )
"

DOCS=( AUTHORS BUGS Changelog README.md TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.1-no-git.patch
	"${FILESDIR}"/${PN}-2.5.1-docs.patch
	"${FILESDIR}"/${PN}-2.5.1-openmp-automagic.patch
	"${FILESDIR}"/${PN}-2.5.1-fits-automagic.patch
)

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

src_configure() {
	mycmakeargs=(
		-DUSE_OPENMP="$(usex openmp)"
		-DUSE_FITS="$(usex fits)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	for lang in ${LANGS} ; do
		if ! use l10n_${lang} ; then
			rm -f "${D}"/usr/share/${PN}/i18n/{lang,qt}_${lang}.qm || die
		fi
	done
}
