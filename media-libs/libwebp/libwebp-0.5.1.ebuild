# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils libtool multilib-minimal

DESCRIPTION="A lossy image compression format"
HOMEPAGE="https://developers.google.com/speed/webp/download"
SRC_URI="http://downloads.webmproject.org/releases/webp/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/6" # subslot = libwebp soname version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~m68k-mint"
IUSE="experimental gif +jpeg opengl +png static-libs swap-16bit-csp tiff"

# TODO: dev-lang/swig bindings in swig/ subdirectory
RDEPEND="gif? ( media-libs/giflib:= )
	jpeg? ( virtual/jpeg:0= )
	opengl? (
		media-libs/freeglut
		virtual/opengl
		)
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0= )"
DEPEND="${RDEPEND}"

ECONF_SOURCE=${S}

src_prepare() {
	default

	# Fix libtool relinking, bug 499270.
	#elibtoolize
	eautoreconf
}

multilib_src_configure() {
	local args=(
		--enable-libwebpmux
		--enable-libwebpdemux
		--enable-libwebpdecoder
		$(use_enable static-libs static)
		$(use_enable swap-16bit-csp)
		$(use_enable experimental)
		$(use_enable jpeg)
		$(use_enable png)
		$(use_enable opengl gl)
		$(use_enable tiff)

		# Only used for gif2webp binary wrt #486646
		$(multilib_native_use_enable gif)
	)

	econf "${args[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	prune_libtool_files
	dodoc AUTHORS ChangeLog doc/*.txt NEWS README{,.mux}
}
