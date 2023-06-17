# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Rendering engine for MathML documents"
HOMEPAGE="http://helm.cs.unibo.it/mml-widget/"
SRC_URI="http://helm.cs.unibo.it/mml-widget/sources/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="mathml svg t1lib"

RDEPEND="
	>=dev-libs/glib-2.2.1:2
	>=dev-libs/popt-1.7
	>=dev-libs/libxml2-2.6.7:2
	mathml? ( media-fonts/texcm-ttf )
	t1lib?	( >=media-libs/t1lib-5:5 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxslt
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${P}-cond-t1.patch
	# Fix building against libxml2[icu], bug #356095
	"${FILESDIR}"/${P}-fix-template.patch
	# Fix building with gold, bug #369117; requires eautoreconf
	"${FILESDIR}"/${P}-underlinking.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-gcc6.patch
	# Fix building against GCC 7, bug #639448
	"${FILESDIR}"/${P}-gcc7.patch
)

src_prepare() {
	default

	# m4 macros from upstream git, required for eautoreconf
	if [[ ! -d ac-helpers ]]; then
		mkdir ac-helpers || die "mkdir failed"
		cp "${FILESDIR}"/binreloc.m4 ac-helpers || die "cp failed"
	fi

	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die
	rm README.MacOSX || die

	AT_M4DIR=ac-helpers eautoreconf
}

src_configure() {
	# --disable-popt will build only the library and not the frontend
	# TFM is needed for SVG, default value is 2
	econf \
		--disable-gmetadom \
		--disable-gtk \
		$(use_enable svg) \
		$(use_with t1lib) \
		--with-popt \
		--enable-libxml2 \
		--enable-libxml2-reader \
		--enable-ps \
		--enable-tfm=2 \
		--enable-builder-cache \
		--enable-breaks \
		--enable-boxml
}

src_install() {
	default
	dodoc ANNOUNCEMENT CONTRIBUTORS HISTORY

	find "${ED}" -name '*.la' -delete || die
}
