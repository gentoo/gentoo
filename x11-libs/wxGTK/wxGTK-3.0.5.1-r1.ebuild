# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="GTK+ version of wxWidgets, a cross-platform C++ GUI toolkit"
HOMEPAGE="https://wxwidgets.org/"
SRC_URI="https://github.com/wxWidgets/wxWidgets/releases/download/v${PV}/wxWidgets-${PV}.tar.bz2"
# no split docs in this release
#	doc? ( https://github.com/wxWidgets/wxWidgets/releases/download/v${PV}/wxWidgets-${PV}-docs-html.tar.bz2 )"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"


IUSE="+X aqua doc debug gstreamer libnotify opengl sdl tiff webkit"


WXSUBVERSION=${PV%.*}.0-gtk3			# 3.0.5.0-gtk3
WXVERSION=${WXSUBVERSION%.*}			# 3.0.5
WXRELEASE=${WXVERSION%.*}-gtk3			# 3.0-gtk3
WXRELEASE_NODOT=${WXRELEASE//./}		# 30-gtk3

SLOT="${WXRELEASE}"

RDEPEND="
	dev-libs/expat[${MULTILIB_USEDEP}]
	sdl? ( media-libs/libsdl2[${MULTILIB_USEDEP}] )
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
	opengl? ( virtual/glu[${MULTILIB_USEDEP}] )
	X? ( x11-base/xorg-proto )"

BDEPEND="
	>=app-eselect/eselect-wxwidgets-20131230
	virtual/pkgconfig[${MULTILIB_USEDEP}]"


LICENSE="wxWinLL-3 GPL-2 doc? ( wxWinFDL-3 )"

S="${WORKDIR}/wxWidgets-${PV}"

PATCHES=(
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
		-e '/WX_VERSION_TAG=/ s:${WX_RELEASE}:${WXVERSIONTAG}:' \
		configure || die
}

multilib_src_configure() {
	local -a myeconfargs

	# X independent options
	myeconfargs+=(
		--with-zlib=sys
		--with-expat=sys
		--enable-compat28
		$(use_with sdl)

		# Don't hard-code libdir's prefix for wx-config
		--libdir='${prefix}'"/$(get_libdir)"
	)

	# debug in >=2.9
	# there is no longer separate debug libraries (gtk2ud)
	# wxDEBUG_LEVEL=1 is the default and we will leave it enabled
	# wxDEBUG_LEVEL=2 enables assertions that have expensive runtime costs.
	# apps can disable these features by building w/ -NDEBUG or wxDEBUG_LEVEL_0.
	# http://docs.wxwidgets.org/3.0/overview_debugging.html
	# https://groups.google.com/group/wx-dev/browse_thread/thread/c3c7e78d63d7777f/05dee25410052d9c
	use debug && myeconfargs+=( --enable-debug=max )

	# wxGTK options
	#   --enable-graphics_ctx - needed for webkit, editra
	#   --without-gnomevfs - bug #203389
	use X && myeconfargs+=(
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
		$(use_with tiff libtiff sys)
	)

	use aqua && \
		myeconfargs+=(
			--enable-graphics_ctx
			--enable-gui
			--with-libpng=sys
			--with-libxpm=sys
			--with-libjpeg=sys
			--with-mac
			--with-opengl
		)
		# cocoa toolkit seems to be broken

	# wxBase options
	use !X && use !aqua && myeconfargs+=( --disable-gui )

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	cd "${S}"/docs || die
	dodoc changes.txt readme.txt
	newdoc base/readme.txt base_readme.txt
	newdoc gtk/readme.txt gtk_readme.txt
# no split docs in this release
#	use doc && HTML_DOCS="${WORKDIR}"/wxWidgets-${PV}-docs-html/.
	einstalldocs

	# Stray windows locale file, bug #650118
	local wxmsw="${ED}usr/share/locale/it/LC_MESSAGES/wxmsw30-gtk3.mo"
	[[ -e ${wxmsw} ]] && rm "${wxmsw}"

	# Unversioned links
	rm "${ED}"/usr/bin/wx{-config,rc}

	# version bakefile presets
	pushd "${ED}"/usr/share/bakefile/presets/ > /dev/null || die
	local f
	for f in wx*; do
		mv "${f}" "${f/wx/wx${WXRELEASE_NODOTSLASH}}"
	done
	popd &> /dev/null
}

pkg_postinst() {
	has_version -b app-eselect/eselect-wxwidgets \
		&& eselect wxwidgets update
}

pkg_postrm() {
	has_version -b app-eselect/eselect-wxwidgets \
		&& eselect wxwidgets update
}
