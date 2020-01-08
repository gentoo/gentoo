# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

MY_PN=libAfterImage

DESCRIPTION="Afterstep's standalone generic image manipulation library"
HOMEPAGE="http://www.afterstep.org/afterimage/index.php"
SRC_URI="ftp://ftp.afterstep.org/stable/${MY_PN}/${MY_PN}-${PV}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="+X cpu_flags_x86_mmx examples gif jpeg nls opengl png static-libs shm +shaping svg tiff truetype"

RDEPEND="
	X?		( x11-libs/libSM
			  x11-libs/libXext
			  x11-libs/libXrender )
	gif?	( media-libs/giflib:0= )
	jpeg?	( virtual/jpeg:0 )
	opengl?	( virtual/opengl )
	png?	( >=media-libs/libpng-1.4:0= )
	svg?	( gnome-base/librsvg:2 )
	tiff?	( media-libs/tiff:0 )
	truetype? ( media-libs/freetype )"
DEPEND="${RDEPEND}
	X?		( x11-base/xorg-proto )
	virtual/pkgconfig
	!!x11-wm/afterstep"
REQUIRED_USE="
	opengl?	 ( X )
	shaping? ( X )
	shm?	 ( X )"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default

	# fix some ldconfig problem in makefile.in
	eapply -p0 "${FILESDIR}"/${PN}-makefile.in.patch
	# fix lib paths in afterimage-config
	eapply -p0 "${FILESDIR}"/${PN}-config.patch
	# fix gif unbundle
	eapply -p0 "${FILESDIR}"/${PN}-gif.patch
	# fix for libpng15 compability
	eapply -p0 "${FILESDIR}"/${PN}-libpng15.patch
	# add giflib-5 API support, bug 571654
	eapply "${FILESDIR}"/${PN}-giflib5-v2.patch
	# do not build examples
	use examples || sed -i \
		-e '/^all:/s/apps//' \
		-e '/^install:/s/install.apps//' \
		Makefile.in || die "sed failed"
	# remove forced flags
	sed -i \
		-e 's/CFLAGS="-O3"//' \
		-e 's/ -rdynamic//' \
		configure.in || die "sed failed"

	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable cpu_flags_x86_mmx mmx-optimization) \
		$(use_enable opengl glx) \
		$(use_enable nls i18n) \
		$(use_enable shaping) \
		$(use_enable shm shmimage ) \
		$(use_enable static-libs staticlibs) \
		$(use_with X x) \
		$(use_with gif) \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_with svg) \
		$(use_with tiff) \
		$(use_with truetype ttf) \
		--enable-sharedlibs \
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
		mv ascompose.man ascompose.1 || die
		doman ascompose.1
		emake clean
		rm Makefile* ascompose.1 || die
		insinto /usr/share/doc/${PF}/examples
		doins *
	fi
}
