# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal flag-o-matic

DESCRIPTION="GTK+ version of wxWidgets, a cross-platform C++ GUI toolkit"
HOMEPAGE="https://wxwidgets.org/"
SRC_URI="
	https://github.com/wxWidgets/wxWidgets/releases/download/v${PV}/wxWidgets-${PV}.tar.bz2
	https://dev.gentoo.org/~leio/distfiles/wxGTK-3.0.4_p20190713.tar.xz
	doc? ( https://github.com/wxWidgets/wxWidgets/releases/download/v${PV}/wxWidgets-${PV}-docs-html.tar.bz2 )"
S="${WORKDIR}/wxWidgets-${PV}"

LICENSE="wxWinLL-3 GPL-2 doc? ( wxWinFDL-3 )"
SLOT="3.0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="+X doc debug gstreamer libnotify opengl pch sdl tiff"

RDEPEND="
	dev-libs/expat[${MULTILIB_USEDEP}]
	sdl? ( media-libs/libsdl2[${MULTILIB_USEDEP}] )
	X? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
		media-libs/libpng:=[${MULTILIB_USEDEP}]
		sys-libs/zlib[${MULTILIB_USEDEP}]
		x11-libs/gtk+:2[${MULTILIB_USEDEP}]
		x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}]
		x11-libs/libSM[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
		x11-libs/pango[${MULTILIB_USEDEP}]
		gstreamer? (
			media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
			media-libs/gst-plugins-base:1.0[${MULTILIB_USEDEP}]
		)
		libnotify? ( x11-libs/libnotify[${MULTILIB_USEDEP}] )
		opengl? ( virtual/opengl[${MULTILIB_USEDEP}] )
		tiff?   ( media-libs/tiff:=[${MULTILIB_USEDEP}] )
	)"
DEPEND="
	${RDEPEND}
	opengl? ( virtual/glu[${MULTILIB_USEDEP}] )
	X? ( x11-base/xorg-proto )"
BDEPEND="virtual/pkgconfig"
PDEPEND=">=app-eselect/eselect-wxwidgets-20131230"

PATCHES=(
	"${WORKDIR}"/wxGTK-3.0.4_p20190713/
	"${FILESDIR}"/${PN}-3.0.5-collision.patch
	"${FILESDIR}"/wxGTK-ignore-c++-abi.patch #676878
)

multilib_src_configure() {
	# Workaround for bug #915154
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	local myconf=(
		# X independent options
		--with-zlib=sys
		--with-expat=sys
		--enable-compat28
		$(use_with sdl)

		# PCHes are unstable and are disabled in-tree where possible
		# See bug #504204
		# Commits 8c4774042b7fdfb08e525d8af4b7912f26a2fdce, fb809aeadee57ffa24591e60cfb41aecd4823090
		$(use_enable pch precomp-headers)
	)

	# debug in >=2.9
	# there is no longer separate debug libraries (gtk2ud)
	# wxDEBUG_LEVEL=1 is the default and we will leave it enabled
	# wxDEBUG_LEVEL=2 enables assertions that have expensive runtime costs.
	# apps can disable these features by building w/ -NDEBUG or wxDEBUG_LEVEL_0.
	# http://docs.wxwidgets.org/3.0/overview_debugging.html
	# https://groups.google.com/group/wx-dev/browse_thread/thread/c3c7e78d63d7777f/05dee25410052d9c
	use debug && myconf+=( --enable-debug=max )

	# wxGTK options
	#   --enable-graphics_ctx - needed for webkit, editra
	#   --without-gnomevfs - bug #203389
	if use X; then
		myconf+=(
			--enable-gui
			--enable-graphics_ctx
			--with-gtkprint
			--with-libpng=sys
			--with-libxpm=sys
			--with-libjpeg=sys
			--without-gnomevfs
			--disable-webview
			$(use_enable gstreamer mediactrl)
			$(use_with libnotify)
			$(use_with opengl)
			$(use_with tiff libtiff sys)
		)
	else
		# wxBase options
		myconf+=( --disable-gui )
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install_all() {
	cd docs || die
	dodoc changes.txt readme.txt
	newdoc base/readme.txt base_readme.txt
	newdoc gtk/readme.txt gtk_readme.txt

	use doc && HTML_DOCS=( "${WORKDIR}"/wxWidgets-${PV}-docs-html/. )
	einstalldocs

	# Stray windows locale file, causes collisions
	rm -f "${ED}"/usr/share/locale/it/LC_MESSAGES/wxmsw.mo || die
}

pkg_postinst() {
	has_version app-eselect/eselect-wxwidgets &&
		eselect wxwidgets update
}

pkg_postrm() {
	has_version app-eselect/eselect-wxwidgets &&
		eselect wxwidgets update
}
