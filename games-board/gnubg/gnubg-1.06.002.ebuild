# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit desktop python-single-r1 xdg

DESCRIPTION="GNU BackGammon"
HOMEPAGE="https://www.gnu.org/software/gnubg/"
SRC_URI="ftp://ftp.gnu.org/gnu/gnubg/${PN}-release-${PV}-sources.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="cpu_flags_x86_avx gtk opengl python sqlite cpu_flags_x86_sse cpu_flags_x86_sse2 threads"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/gmp:0
	dev-libs/libxml2
	media-fonts/dejavu
	media-libs/freetype:2
	media-libs/libcanberra
	media-libs/libpng:0
	sys-libs/readline:0
	x11-libs/cairo
	x11-libs/pango
	gtk? ( x11-libs/gtk+:2 )
	opengl? (
		x11-libs/gtk+:2
		x11-libs/gtkglext
		virtual/glu
	)
	python? ( ${PYTHON_DEPS} )
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# use ${T} instead of /tmp for constructing credits (bug #298275)
	sed -i -e 's:/tmp:${T}:' credits.sh || die
	sed -i -e 's/fonts //' Makefile.in || die # handle font install ourself to fix bug #335774
	sed -i \
		-e '/^localedir / s#=.*$#= @localedir@#' \
		-e '/^gnulocaledir / s#=.*$#= @localedir@#' \
		po/Makefile.in.in || die
	sed -i \
		-e '/^gnubgiconsdir / s#=.*#= /usr/share#' \
		-e '/^gnubgpixmapsdir / s#=.*#= /usr/share/pixmaps#' \
		pixmaps/Makefile.in || die
	sed -i \
		-e '1i#include <config.h>' \
		copying.c || die #551896
}

src_configure() {
	local simd=no
	local gtk_arg=--without-gtk

	if use gtk || use opengl ; then
		gtk_arg=--with-gtk
	fi
	use cpu_flags_x86_sse  && simd=sse
	use cpu_flags_x86_sse2 && simd=sse2
	use cpu_flags_x86_avx  && simd=avx
	econf \
		--localedir=/usr/share/locale \
		--docdir=/usr/share/doc/${PF}/html \
		--disable-cputest \
		--enable-simd=${simd} \
		${gtk_arg} \
		$(use_enable threads) \
		$(usex python --with-python=${EPYTHON} --without-python) \
		$(use_with sqlite sqlite) \
		$(use_with opengl board3d)
}

src_install() {
	default
	insinto /usr/share/${PN}
	doins ${PN}.weights *bd
	dodir /usr/share/${PN}/fonts
	dosym ../../fonts/dejavu/DejaVuSans.ttf /usr/share/${PN}/fonts/Vera.ttf
	dosym ../../fonts/dejavu/DejaVuSans-Bold.ttf /usr/share/${PN}/fonts/VeraBd.ttf
	dosym ../../fonts/dejavu/DejaVuSerif-Bold.ttf /usr/share/${PN}/fonts/VeraSeBd.ttf
	make_desktop_entry "gnubg -w" "GNU Backgammon"
}
