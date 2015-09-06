# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic

DESCRIPTION="GTK+ version of wxWidgets, a cross-platform C++ GUI toolkit"
HOMEPAGE="http://wxwidgets.org/"

# we use the wxPython tarballs because they include the full wxGTK sources and
# docs, and are released more frequently than wxGTK.
SRC_URI="mirror://sourceforge/wxpython/wxPython-src-${PV}.tar.bz2
	doc? ( mirror://sourceforge/wxpython/wxPython-docs-${PV}.tar.bz2 )"

KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+X aqua doc debug gstreamer libnotify opengl sdl tiff webkit"

SLOT="3.0"

RDEPEND="
	dev-libs/expat
	sdl?    ( media-libs/libsdl )
	X?  (
		>=dev-libs/glib-2.22:2
		media-libs/libpng:0=
		sys-libs/zlib
		virtual/jpeg
		>=x11-libs/gtk+-2.18:2
		x11-libs/gdk-pixbuf
		x11-libs/libSM
		x11-libs/libXxf86vm
		x11-libs/pango[X]
		gstreamer? (
			media-libs/gstreamer:0.10
			media-libs/gst-plugins-base:0.10 )
		libnotify? ( x11-libs/libnotify )
		opengl? ( virtual/opengl )
		tiff?   ( media-libs/tiff:0 )
		webkit? ( net-libs/webkit-gtk:2 )
		)
	aqua? (
		>=x11-libs/gtk+-2.4[aqua=]
		virtual/jpeg
		tiff?   ( media-libs/tiff:0 )
		)"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	opengl? ( virtual/glu )
	X?  (
		x11-proto/xproto
		x11-proto/xineramaproto
		x11-proto/xf86vidmodeproto
		)"

PDEPEND=">=app-eselect/eselect-wxwidgets-20131230"

LICENSE="wxWinLL-3
		GPL-2
		doc?	( wxWinFDL-3 )"

S="${WORKDIR}/wxPython-src-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.0.0.0-collision.patch

	# https://bugs.gentoo.org/421851
	# https://bugs.gentoo.org/499984
	# https://bugs.gentoo.org/536004
	sed \
		-e "/wx_cv_std_libpath=/s:=.*:=$(get_libdir):" \
		-e 's:3\.0\.1:3.0.2:g' \
		-e 's:^wx_release_number=1$:wx_release_number=2:' \
		-i configure || die

	epatch_user
}

src_configure() {
	local myconf

	# X independent options
	myconf="
			--with-zlib=sys
			--with-expat=sys
			--enable-compat28
			$(use_with sdl)"

	# debug in >=2.9
	# there is no longer separate debug libraries (gtk2ud)
	# wxDEBUG_LEVEL=1 is the default and we will leave it enabled
	# wxDEBUG_LEVEL=2 enables assertions that have expensive runtime costs.
	# apps can disable these features by building w/ -NDEBUG or wxDEBUG_LEVEL_0.
	# http://docs.wxwidgets.org/3.0/overview_debugging.html
	# https://groups.google.com/group/wx-dev/browse_thread/thread/c3c7e78d63d7777f/05dee25410052d9c
	use debug \
		&& myconf="${myconf} --enable-debug=max"

	# wxGTK options
	#   --enable-graphics_ctx - needed for webkit, editra
	#   --without-gnomevfs - bug #203389
	use X && \
		myconf="${myconf}
			--enable-graphics_ctx
			--with-gtkprint
			--enable-gui
			--with-libpng=sys
			--with-libxpm=sys
			--with-libjpeg=sys
			--without-gnomevfs
			$(use_enable gstreamer mediactrl)
			$(use_enable webkit webview)
			$(use_with libnotify)
			$(use_with opengl)
			$(use_with tiff libtiff sys)"

	use aqua && \
		myconf="${myconf}
			--enable-graphics_ctx
			--enable-gui
			--with-libpng=sys
			--with-libxpm=sys
			--with-libjpeg=sys
			--with-mac
			--with-opengl"
			# cocoa toolkit seems to be broken

	# wxBase options
	if use !X && use !aqua ; then
		myconf="${myconf}
			--disable-gui"
	fi

	mkdir "${S}"/wxgtk_build
	cd "${S}"/wxgtk_build

	ECONF_SOURCE="${S}" econf ${myconf}
}

src_compile() {
	cd "${S}"/wxgtk_build
	emake
}

src_install() {
	cd "${S}"/wxgtk_build

	emake DESTDIR="${D}" install

	cd "${S}"/docs
	dodoc changes.txt readme.txt
	newdoc base/readme.txt base_readme.txt
	newdoc gtk/readme.txt gtk_readme.txt

	if use doc; then
		dohtml -r "${S}"/docs/doxygen/out/html/*
	fi

	# Stray windows locale file, causes collisions
	local wxmsw="${ED}usr/share/locale/it/LC_MESSAGES/wxmsw.mo"
	[[ -e ${wxmsw} ]] && rm "${wxmsw}"
}

pkg_postinst() {
	has_version app-eselect/eselect-wxwidgets \
		&& eselect wxwidgets update
}

pkg_postrm() {
	has_version app-eselect/eselect-wxwidgets \
		&& eselect wxwidgets update
}
