# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="GTK+ version of wxWidgets, a cross-platform C++ GUI toolkit"
HOMEPAGE="https://wxwidgets.org/"
SRC_URI="https://github.com/wxWidgets/wxWidgets/releases/download/v${PV}/wxWidgets-${PV}.tar.bz2
	https://dev.gentoo.org/~leio/distfiles/wxGTK-3.0.4_p20180507.tar.xz
	doc? ( https://github.com/wxWidgets/wxWidgets/releases/download/v${PV}/wxWidgets-${PV}-docs-html.tar.bz2 )"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+X aqua doc debug gstreamer libnotify opengl sdl tiff"

SLOT="3.0"

RDEPEND="
	dev-libs/expat[${MULTILIB_USEDEP}]
	sdl? ( media-libs/libsdl[${MULTILIB_USEDEP}] )
	X? (
		>=dev-libs/glib-2.22:2[${MULTILIB_USEDEP}]
		media-libs/libpng:0=[${MULTILIB_USEDEP}]
		sys-libs/zlib[${MULTILIB_USEDEP}]
		virtual/jpeg:0=[${MULTILIB_USEDEP}]
		>=x11-libs/gtk+-2.18:2[${MULTILIB_USEDEP}]
		x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}]
		x11-libs/libSM[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
		x11-libs/pango[${MULTILIB_USEDEP}]
		gstreamer? (
			media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
			media-libs/gst-plugins-base:1.0[${MULTILIB_USEDEP}] )
		libnotify? ( x11-libs/libnotify[${MULTILIB_USEDEP}] )
		opengl? ( virtual/opengl[${MULTILIB_USEDEP}] )
		tiff?   ( media-libs/tiff:0[${MULTILIB_USEDEP}] )
		)
	aqua? (
		x11-libs/gtk+:2[aqua=,${MULTILIB_USEDEP}]
		virtual/jpeg:0=[${MULTILIB_USEDEP}]
		tiff?   ( media-libs/tiff:0[${MULTILIB_USEDEP}] )
		)"

DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	opengl? ( virtual/glu[${MULTILIB_USEDEP}] )
	X? ( x11-base/xorg-proto )"

PDEPEND=">=app-eselect/eselect-wxwidgets-20131230"

LICENSE="wxWinLL-3 GPL-2 doc? ( wxWinFDL-3 )"

S="${WORKDIR}/wxWidgets-${PV}"
PATCHES=(
	"${WORKDIR}"/wxGTK-3.0.4_p20180507/
	"${FILESDIR}"/${PN}-3.0.3-collision.patch
)

multilib_src_configure() {
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
			--disable-webview
			$(use_enable gstreamer mediactrl)
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

	ECONF_SOURCE="${S}" econf ${myconf}
}

multilib_src_install_all() {
	cd "${S}"/docs || die
	dodoc changes.txt readme.txt
	newdoc base/readme.txt base_readme.txt
	newdoc gtk/readme.txt gtk_readme.txt

	use doc && HTML_DOCS="${WORKDIR}"/wxWidgets-${PV}-docs-html/.
	einstalldocs

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
