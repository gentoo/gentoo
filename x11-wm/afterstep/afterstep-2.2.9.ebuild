# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools flag-o-matic eutils

DESCRIPTION="A feature rich NeXTish window manager"
HOMEPAGE="http://www.afterstep.org/"
SRC_URI="ftp://ftp.afterstep.org/stable/AfterStep-${PV}.tar.bz2"

# libAfterBase/libAfterImage are LGPL
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="alsa debug dbus gif gtk jpeg cpu_flags_x86_mmx nls png svg tiff xinerama"

RDEPEND="
	media-libs/freetype
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	jpeg? ( virtual/jpeg )
	gif?  ( >=media-libs/giflib-4.1.0 )
	gtk? ( x11-libs/gtk+:2 )
	png? ( media-libs/libpng:0 )
	svg? ( gnome-base/librsvg:2 )
	tiff? ( media-libs/tiff:0 )
	x11-libs/libICE
	x11-libs/libXext
	x11-libs/libSM
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXrender
	xinerama? ( x11-libs/libXinerama )"

DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto
	xinerama? ( x11-proto/xineramaproto )
	!!media-libs/libafterimage"

S=${WORKDIR}/AfterStep-${PV}

src_prepare() {
	epatch \
		"${FILESDIR}"/no-alternatives-${PV}.patch \
		"${FILESDIR}"/${P}-make_session_data_file.patch \
		"${FILESDIR}"/${P}-alpha.patch \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-libpng15.patch

	sed -i \
		-e '/CFLAGS="-O3"/d' \
		libAfter{Base,Image}/configure || die

	sed -i \
		-e "/STRIP_BINARIES/s/-s//" \
		autoconf/configure.in || die #252119

	sed -i \
		-e '/--with-builtin-gif/s/$with_gif/no/' \
		autoconf/configure.in || die #253259

	cd "${S}"/autoconf || die
	eautoreconf
	cp "${S}"/autoconf/autoconf/config.h.in "${S}"/autoconf || die
	cp "${S}"/autoconf/configure "${S}" || die
}

src_configure() {
	local myconf

	use debug && myconf="--enable-gdb --enable-warn --enable-gprof
		--enable-audit --enable-trace --enable-trace-x"

	#implied intent of debug means you need the frame pointers.
	use debug && filter-flags -fomit-frame-pointer

	# Explanation of configure options
	# ================================
	# --with-helpcommand="xterm -e man" -  Avoid installing xiterm
	# --with-xpm - Contained in xfree
	# --disable-availability - So we can use complete paths for menuitems
	# --enable-ascp - The AfterStep ControlPanel is abandoned
	# LDCONFIG - bug #265841

	LDCONFIG=/bin/true econf \
		$(use_enable alsa) \
		$(use_enable cpu_flags_x86_mmx mmx-optimization) \
		$(use_enable nls i18n) \
		$(use_enable xinerama) \
		$(use_with dbus dbus1) \
		$(use_with gif) \
		$(use_with gtk) \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_with tiff) \
		$(use_with svg) \
		--with-helpcommand="xterm -e man" \
		--disable-availability \
		--disable-staticlibs \
		--enable-ascp=no \
		${myconf}
}

src_compile() {
	# gcc: ../libAfterConf/libAfterConf.a: No such file or directory
	# make[1]: *** [PrintDesktopEntries] Error 1
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" install

	# Create a symlink from MonitorWharf to Wharf
	rm "${D}"/usr/bin/MonitorWharf
	dosym /usr/bin/Wharf /usr/bin/MonitorWharf

	# Handle the documentation
	dodoc ChangeLog INSTALL NEW* README* TEAM UPGRADE
	cp -pPR "${S}"/TODO "${D}"/usr/share/doc/${PF}/
	dodir /usr/share/doc/${PF}/html
	cp -pPR "${S}"/doc/* "${D}"/usr/share/doc/${PF}/html
	rm "${D}"/usr/share/doc/${PF}/html/{Makefile*,afterstepdoc.in}

	insinto /usr/share/xsessions
	newins "${S}"/AfterStep.desktop.final AfterStep.desktop

	# For desktop managers like GDM or KDE
	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}"/afterstep
}
