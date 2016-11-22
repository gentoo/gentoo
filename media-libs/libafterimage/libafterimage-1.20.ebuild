# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools

MY_PN=libAfterImage

DESCRIPTION="Afterstep's standalone generic image manipulation library"
HOMEPAGE="http://www.afterstep.org/afterimage/index.php"
SRC_URI="ftp://ftp.afterstep.org/stable/${MY_PN}/${MY_PN}-${PV}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="examples gif jpeg cpu_flags_x86_mmx nls png static-libs svg tiff truetype"

RDEPEND="
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/libXrender
	png?  ( >=media-libs/libpng-1.4:0 )
	jpeg? ( virtual/jpeg:= )
	gif?  ( <media-libs/giflib-5 )
	svg? ( gnome-base/librsvg )
	tiff? ( media-libs/tiff:0 )
	truetype? ( media-libs/freetype )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xextproto
	!!x11-wm/afterstep"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	# fix some ldconfig problem in makefile.in
	epatch "${FILESDIR}"/${PN}-makefile.in.patch
	# fix lib paths in afterimage-config
	epatch "${FILESDIR}"/${PN}-config.patch
	# fix gif unbundle
	epatch "${FILESDIR}"/${PN}-gif.patch
	# fix for libpng15 compability
	epatch "${FILESDIR}"/${PN}-libpng15.patch
	# fix for gif library bug  #486804
	epatch "${FILESDIR}"/${PN}-giflib42.patch
	# do not build examples
	sed -i \
		-e '/^all:/s/apps//' \
		-e '/^install:/s/install.apps//' \
		Makefile.in || die
	# remove forced flags
	sed -i \
		-e 's/CFLAGS="-O3"//' \
		-e 's/ -rdynamic//' \
		configure.in || die "sed failed"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs staticlibs) \
		$(use_enable nls i18n) \
		$(use_enable cpu_flags_x86_mmx mmx-optimization) \
		$(use_with png) \
		$(use_with jpeg) \
		$(use_with gif) \
		$(use_with svg) \
		$(use_with tiff) \
		$(use_with truetype ttf) \
		--enable-glx \
		--enable-sharedlibs \
		--with-x \
		--with-xpm \
		--without-builtin-gif \
		--without-builtin-jpeg \
		--without-builtin-png \
		--without-builtin-zlib \
		--without-afterbase
}

src_install() {
	emake \
		DESTDIR="${D}" \
		AFTER_DOC_DIR="${ED}/usr/share/doc/${PF}" \
		install
	dodoc ChangeLog README
	if use examples; then
		cd apps || die
		emake clean
		rm Makefile* || die
		insinto /usr/share/doc/${PF}/examples
		doins *
	fi
}
