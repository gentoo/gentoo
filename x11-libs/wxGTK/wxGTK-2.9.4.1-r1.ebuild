# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/wxGTK/wxGTK-2.9.4.1-r1.ebuild,v 1.3 2015/03/31 20:05:20 ulm Exp $

EAPI="5"

inherit eutils flag-o-matic

DESCRIPTION="GTK+ version of wxWidgets, a cross-platform C++ GUI toolkit"
HOMEPAGE="http://wxwidgets.org/"

# we use the wxPython tarballs because they include the full wxGTK sources and
# docs, and are released more frequently than wxGTK.
SRC_URI="mirror://sourceforge/wxpython/wxPython-src-2.9.4.0.tar.bz2
	doc? ( mirror://sourceforge/wxpython/wxPython-docs-2.9.4.0.tar.bz2 )
	mirror://sourceforge/wxpython/wxPython-src-${PV}.patch"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+X aqua doc debug gnome gstreamer opengl pch sdl tiff webkit"

SLOT="2.9/2.9.4"

RDEPEND="
	dev-libs/expat
	sdl?    ( media-libs/libsdl )
	X?  (
		>=dev-libs/glib-2.22:2
		media-libs/libpng:0=
		sys-libs/zlib
		virtual/jpeg
		>=x11-libs/gtk+-2.18:2
		x11-libs/libSM
		x11-libs/libXinerama
		x11-libs/libXxf86vm
		x11-libs/pango[X]
		gnome? ( gnome-base/libgnomeprintui:2.2 )
		gstreamer? (
			media-libs/gstreamer:0.10
			media-libs/gst-plugins-base:0.10 )
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
#	test? ( dev-util/cppunit )

PDEPEND=">=app-eselect/eselect-wxwidgets-1.4"

LICENSE="wxWinLL-3
		GPL-2
		doc?	( wxWinFDL-3 )"

S="${WORKDIR}/wxPython-src-2.9.4.0"

src_prepare() {
	epatch "${FILESDIR}"/${P}-collision.patch
	epatch "${DISTDIR}"/wxPython-src-${PV}.patch
	epatch_user
}

src_configure() {
	local myconf

	append-flags -fno-strict-aliasing

	# X independent options
	myconf="--enable-compat26
			--with-zlib=sys
			--with-expat=sys
			$(use_enable pch precomp-headers)
			$(use_with sdl)"

	# debug in >=2.9
	#   if USE="debug" set max debug level (wxDEBUG_LEVEL=2)
	#   if USE="-debug" use the default (wxDEBUG_LEVEL=1)
	#   do not use --disable-debug
	# this means we always build debugging features into the library, and
	# apps can disable these features by building w/ -NDEBUG or wxDEBUG_LEVEL_0.
	# wxDEBUG_LEVEL=2 enables assertions that have expensive runtime costs.
	# http://docs.wxwidgets.org/2.9/overview_debugging.html
	# http://groups.google.com/group/wx-dev/browse_thread/thread/c3c7e78d63d7777f/05dee25410052d9c
	use debug \
		&& myconf="${myconf} --enable-debug=max"

	# wxGTK options
	#   --enable-graphics_ctx - needed for webkit, editra
	#   --without-gnomevfs - bug #203389
	use X && \
		myconf="${myconf}
			--enable-graphics_ctx
			--enable-gui
			--with-libpng=sys
			--with-libxpm=sys
			--with-libjpeg=sys
			--without-gnomevfs
			$(use_enable gstreamer mediactrl)
			$(use_enable webkit webview)
			$(use_with opengl)
			$(use_with gnome gnomeprint)
			$(use_with !gnome gtkprint)
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

# Currently fails - need to investigate
#src_test() {
#	cd "${S}"/wxgtk_build/tests
#	emake || die "failed building testsuite"
#	./test -d || ewarn "failed running testsuite"
#}

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
