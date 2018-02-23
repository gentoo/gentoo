# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="GTK+ version of wxWidgets, a cross-platform C++ GUI toolkit"
HOMEPAGE="https://wxwidgets.org/"
SRC_URI="https://github.com/wxWidgets/wxWidgets/releases/download/v${PV}/wxWidgets-${PV}.tar.bz2
	https://dev.gentoo.org/~leio/distfiles/wxGTK-3.0.3_p20180104.tar.xz
	doc? ( https://github.com/wxWidgets/wxWidgets/releases/download/v${PV}/wxWidgets-${PV}-docs-html.tar.bz2 )"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc64 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+X aqua doc debug gstreamer libnotify opengl sdl tiff webkit"

WXSUBVERSION=${PV}.0-gtk3			# 3.0.3.0-gtk3
WXVERSION=${WXSUBVERSION%.*}			# 3.0.3
WXRELEASE=${WXVERSION%.*}-gtk3			# 3.0-gtk3
WXRELEASE_NODOT=${WXRELEASE//./}		# 30-gtk3

SLOT="${WXRELEASE}"

RDEPEND="
	dev-libs/expat[${MULTILIB_USEDEP}]
	sdl? ( media-libs/libsdl[${MULTILIB_USEDEP}] )
	X? (
		>=dev-libs/glib-2.22:2[${MULTILIB_USEDEP}]
		media-libs/libpng:0=[${MULTILIB_USEDEP}]
		sys-libs/zlib[${MULTILIB_USEDEP}]
		virtual/jpeg:0=[${MULTILIB_USEDEP}]
		x11-libs/cairo[${MULTILIB_USEDEP}]
		x11-libs/gtk+:3[${MULTILIB_USEDEP}]
		x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}]
		x11-libs/libSM[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
		x11-libs/pango[${MULTILIB_USEDEP}]
		gstreamer? (
			media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
			media-libs/gst-plugins-base:1.0[${MULTILIB_USEDEP}] )
		libnotify? ( x11-libs/libnotify[${MULTILIB_USEDEP}] )
		opengl? ( virtual/opengl[${MULTILIB_USEDEP}] )
		tiff?   ( media-libs/tiff:0[${MULTILIB_USEDEP}] )
		webkit? ( net-libs/webkit-gtk:4 )
		)
	aqua? (
		x11-libs/gtk+:3[aqua=,${MULTILIB_USEDEP}]
		virtual/jpeg:0=[${MULTILIB_USEDEP}]
		tiff?   ( media-libs/tiff:0[${MULTILIB_USEDEP}] )
		)"

DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	opengl? ( virtual/glu[${MULTILIB_USEDEP}] )
	X? (
		x11-proto/xproto[${MULTILIB_USEDEP}]
		x11-proto/xineramaproto[${MULTILIB_USEDEP}]
		x11-proto/xf86vidmodeproto[${MULTILIB_USEDEP}]
	)"

PDEPEND=">=app-eselect/eselect-wxwidgets-20131230"

LICENSE="wxWinLL-3 GPL-2 doc? ( wxWinFDL-3 )"

S="${WORKDIR}/wxWidgets-${PV}"

PATCHES=(
	"${WORKDIR}"/wxGTK-3.0.3_p20180104/
	"${FILESDIR}"/wxGTK-${SLOT}-translation-domain.patch
)

src_prepare() {
	default

	# Versionating
	sed -i \
		-e "s:\(WX_RELEASE = \).*:\1${WXRELEASE}:"\
		-e "s:\(WX_RELEASE_NODOT = \).*:\1${WXRELEASE_NODOT}:"\
		-e "s:\(WX_VERSION = \).*:\1${WXVERSION}:"\
		-e "s:aclocal):aclocal/wxwin${WXRELEASE_NODOT}.m4):" \
		-e "s:wxstd.mo:wxstd${WXRELEASE_NODOT}.mo:" \
		-e "s:wxmsw.mo:wxmsw${WXRELEASE_NODOT}.mo:" \
		Makefile.in || die

	sed -i \
		-e "s:\(WX_RELEASE = \).*:\1${WXRELEASE}:"\
		utils/wxrc/Makefile.in || die

	sed -i \
		-e "s:\(WX_VERSION=\).*:\1${WXVERSION}:" \
		-e "s:\(WX_RELEASE=\).*:\1${WXRELEASE}:" \
		-e "s:\(WX_SUBVERSION=\).*:\1${WXSUBVERSION}:" \
		-e '/WX_VERSION_TAG=/ s:${WX_RELEASE}:3.0:' \
		configure || die
}

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
			--with-gtk=3
			--with-libpng=sys
			--with-libjpeg=sys
			--without-gnomevfs
			$(use_enable gstreamer mediactrl)
			$(multilib_native_use_enable webkit webview)
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

	# Unversioned links
	rm "${D}"/usr/bin/wx{-config,rc}

	# version bakefile presets
	pushd "${D}"usr/share/bakefile/presets/ > /dev/null
	for f in wx*; do
		mv "${f}" "${f/wx/wx30gtk3}"
	done
	popd > /dev/null
}

pkg_postinst() {
	has_version app-eselect/eselect-wxwidgets \
		&& eselect wxwidgets update
}

pkg_postrm() {
	has_version app-eselect/eselect-wxwidgets \
		&& eselect wxwidgets update
}
