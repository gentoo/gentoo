# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit autotools desktop python-single-r1 xdg

DESCRIPTION="GNU BackGammon"
HOMEPAGE="https://www.gnu.org/software/gnubg/"
SRC_URI="mirror://gnu/${PN}/${PN}-release-${PV}-sources.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="
	cpu_flags_x86_avx cpu_flags_x86_sse cpu_flags_x86_sse2
	gui opengl python sqlite"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	opengl? ( gui )"

RDEPEND="
	dev-libs/cglm
	dev-libs/glib:2
	dev-libs/gmp:=
	media-fonts/dejavu
	media-libs/freetype:2
	media-libs/libpng:=
	net-misc/curl
	sys-libs/readline:=
	virtual/libintl
	x11-libs/cairo[svg(+)]
	x11-libs/pango
	gui? (
		media-libs/libcanberra[gtk3]
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
	)
	opengl? ( media-libs/libepoxy )
	python? ( ${PYTHON_DEPS} )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/autoconf-archive
	sys-devel/gettext
	virtual/pkgconfig
	python? ( ${PYTHON_DEPS} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	#This was provided by gtkglext before
	sed -i "s/\$(GTKGLEXT_LIBS)/-lGL/" Makefile.am || die

	sed -i "s|/tmp|${T}|" credits.sh || die #298275
	sed -i 's/fonts //' Makefile.am || die #335774
	sed -i 's/gzip/true/' doc/Makefile.am || die

	# use system's copy so py3.10 distutils warning doesn't trigger a fatal error
	rm m4/ax_python_devel.m4 || die

	eautoreconf
}

src_configure() {
	local simd=no
	use cpu_flags_x86_sse  && simd=sse
	use cpu_flags_x86_sse2 && simd=sse2
	use cpu_flags_x86_avx  && simd=avx

	local econfargs=(
		$(use_with gui gtk)
		$(use_with gui gtk3)
		$(use_with opengl board3d)
		$(use_with python)
		$(use_with sqlite)
		--disable-cputest
		--docdir="${EPREFIX}"/usr/share/doc/${PF}/html
		--enable-simd=${simd}
	)

	econf "${econfargs[@]}"
}

src_install() {
	default

	mv "${ED}"/usr/share/doc/${PF}{/html/*.pdf,} || die

	insinto /usr/share/${PN}
	doins ${PN}.weights *.bd

	dosym ../../fonts/dejavu/DejaVuSans.ttf /usr/share/${PN}/fonts/Vera.ttf
	dosym ../../fonts/dejavu/DejaVuSans-Bold.ttf /usr/share/${PN}/fonts/VeraBd.ttf
	dosym ../../fonts/dejavu/DejaVuSerif-Bold.ttf /usr/share/${PN}/fonts/VeraSeBd.ttf

	use gui && make_desktop_entry "gnubg -w" "GNU Backgammon"
}
