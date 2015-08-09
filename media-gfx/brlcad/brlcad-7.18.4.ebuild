# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit eutils java-pkg-opt-2 multilib

DESCRIPTION="Constructive solid geometry modeling system"
HOMEPAGE="http://brlcad.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="benchmarks debug doc examples java opengl smp"

RDEPEND="media-libs/libpng
	sys-libs/zlib
	>=sci-libs/tnt-3
	sci-libs/jama
	=dev-tcltk/itcl-3.4*
	=dev-tcltk/itk-3.4*
	dev-tcltk/iwidgets
	dev-tcltk/tkimg
	dev-tcltk/tkpng
	sys-libs/libtermcap-compat
	media-libs/urt
	x11-libs/libXt
	x11-libs/libXi
	java? ( >=virtual/jre-1.5 )"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	java? ( >=virtual/jdk-1.5 )
	doc? ( dev-libs/libxslt )"

BRLCAD_DIR="${EPREFIX}/usr/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng15.patch

	java-pkg-opt-2_src_prepare
}

src_configure() {
	local myconf="--without-jdk"
	use java &&	myconf="--with-jdk=$(java-config -O)"

	econf \
		--disable-strict-build \
		--prefix="${BRLCAD_DIR}" \
		--datadir="${BRLCAD_DIR}/share" \
		--mandir="${BRLCAD_DIR}/man" \
		--disable-almost-everything \
		--disable-regex-build \
		--disable-png-build \
		--disable-zlib-build \
		--disable-urt-build \
		--disable-tcl-build \
		--disable-tk-build \
		--disable-itcl-build \
		--disable-tkimg-build \
		--disable-jove-build \
		--disable-tnt-install \
		--disable-iwidgets-install \
		--enable-opennurbs-build \
		--with-ldflags="-L${EPREFIX}/usr/$(get_libdir)/itcl3.4 -L${EPREFIX}/usr/$(get_libdir)/itk3.4" \
		--with-x \
		--with-x11 \
		$(use_enable debug) \
		$(use_enable debug optimization) \
		$(use_enable debug runtime-debug) \
		$(use_enable debug verbose) \
		$(use_enable debug warnings) \
		$(use_enable debug progress) \
		$(use_enable doc documentation) \
		$(use_enable examples models-install) \
		$(use_enable smp parallel) \
		$(use_with opengl ogl) \
		${myconf}
}

src_test() {
	emake check || die "emake check failed"
	if use benchmarks; then
		emake benchmark || die "emake benchmark failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -f "${D}"usr/share/brlcad/{README,NEWS,AUTHORS,HACKING,INSTALL,COPYING}
	dodoc AUTHORS NEWS README HACKING TODO BUGS ChangeLog
	echo "PATH=\"${BRLCAD_DIR}/bin\"" >  99brlcad
	echo "MANPATH=\"${BRLCAD_DIR}/man\"" >> 99brlcad
	doenvd 99brlcad || die
	newicon misc/macosx/Resources/ReadMe.rtfd/brlcad_logo_tiny.png brlcad.png
	make_desktop_entry mged "BRL-CAD" brlcad "Graphics;Engineering"
}
