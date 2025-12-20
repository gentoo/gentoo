# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_QA_COMPAT_SKIP=1  # unused vendored libraries cause warnings
inherit cmake-multilib flag-o-matic toolchain-funcs

# Make sure that this matches the number of components in ${PV}
WXVERSION="$(ver_cut 1-2)"
WXRELEASE="${WXVERSION}-gtk3"			# 3.2-gtk3

DESCRIPTION="GTK version of wxWidgets, a cross-platform C++ GUI toolkit"
HOMEPAGE="https://wxwidgets.org/"
SRC_URI="
	https://github.com/wxWidgets/wxWidgets/releases/download/v${PV}/wxWidgets-${PV}.tar.bz2
	doc? ( https://github.com/wxWidgets/wxWidgets/releases/download/v${PV}/wxWidgets-${PV}-docs-html.tar.bz2 )"
S="${WORKDIR}/wxWidgets-${PV}"

LICENSE="wxWinLL-3 GPL-2 doc? ( wxWinFDL-3 )"
SLOT="${WXRELEASE}/3.2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+X curl doc debug keyring gstreamer libnotify +lzma opengl pch sdl +spell test tiff wayland webkit"
REQUIRED_USE="
	test? ( tiff )
	tiff? ( || ( X wayland ) ) spell? ( || ( X wayland ) )"
RESTRICT="!test? ( test )"

COMMON_GUI_RDEPEND="
	>=dev-libs/glib-2.22:2[${MULTILIB_USEDEP}]
	dev-libs/libmspack
	media-libs/fontconfig
	media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	x11-libs/cairo[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.24.41-r1:3[wayland?,X?,${MULTILIB_USEDEP}]
	x11-libs/libxkbcommon[X?]
	x11-libs/pango[${MULTILIB_USEDEP}]
	gstreamer? (
		media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
		media-libs/gst-plugins-base:1.0[${MULTILIB_USEDEP}]
		media-libs/gst-plugins-bad:1.0[${MULTILIB_USEDEP}]
	)
	libnotify? ( x11-libs/libnotify[${MULTILIB_USEDEP}] )
	opengl? (
		virtual/opengl[${MULTILIB_USEDEP}]
		wayland? ( dev-libs/wayland )
	)
	sdl? ( media-libs/libsdl2[${MULTILIB_USEDEP}] )
	spell? ( app-text/gspell:= )
	tiff? ( media-libs/tiff:=[${MULTILIB_USEDEP}] )
	webkit? ( net-libs/webkit-gtk:4.1= )
"
RDEPEND="
	>=app-eselect/eselect-wxwidgets-20131230
	dev-libs/expat[${MULTILIB_USEDEP}]
	dev-libs/libpcre2[pcre16,pcre32,unicode]
	virtual/zlib:=[${MULTILIB_USEDEP}]
	curl? ( net-misc/curl )
	keyring? ( app-crypt/libsecret )
	lzma? ( app-arch/xz-utils )
	X? ( ${COMMON_GUI_RDEPEND}
		x11-libs/libSM[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXtst
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	)
	wayland? ( ${COMMON_GUI_RDEPEND} )
"
DEPEND="${RDEPEND}
	opengl? ( virtual/glu[${MULTILIB_USEDEP}] )
	X? ( x11-base/xorg-proto )"
BDEPEND="
	test? ( >=dev-util/cppunit-1.8.0 )
	>=app-eselect/eselect-wxwidgets-20131230
	virtual/pkgconfig"

# Note about the gst-plugins-base dep: The build system queries for it,
# but doesn't link it for some reason?  Either way - probably best to
# depend on it anyway.
# X11/Wayland support is decided by testing GDK in build/cmake/modules/FindGTK3.cmake
# and is configured by -DGENTOO_GTK_HIDE_WAYLAND and -DGENTOO_GTK_HIDE_X11

PATCHES=(
	"${FILESDIR}/${PN}-3.2.1-prefer-lib64-in-tests.patch"
	"${FILESDIR}/${P}-wxuilocale-getinfo-failed.patch"
)

src_prepare() {
	# tests that require network access
	sed -i "s:net/.*::g" build/cmake/tests/base/CMakeLists.txt || die

	cmake_src_prepare
}

multilib_src_configure() {
	# defang automagic dependencies, bug #927952
	use wayland || append-cppflags -DGENTOO_GTK_HIDE_WAYLAND
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11

	# bug #952961
	tc-is-lto && filter-flags -fno-semantic-interposition

	# Workaround for bug #915154
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	# See build/cmake/options.cmake for options

	# non-GUI options
	local mycmakeargs=(
		-DwxUSE_ZLIB=sys
		-DwxUSE_EXPAT=sys
		# Choosing to enable this unconditionally seems fair, pcre2 is
		# almost certain to be installed.
		-DwxUSE_REGEX=sys
		-DwxBUILD_COMPATIBILITY=3.0
		-DwxUSE_XRC=ON
		-DwxUSE_LIBLZMA="$(usex lzma)"
		-DwxUSE_SECRETSTORE="$(usex keyring ON OFF)"
		# Currently defaults to curl, could change.  Watch the VDB!
		-DwxUSE_WEBREQUEST="$(usex curl)"

		# PCHes are unstable and are disabled in-tree where possible
		# See bug #504204
		# Commits 8c4774042b7fdfb08e525d8af4b7912f26a2fdce, fb809aeadee57ffa24591e60cfb41aecd4823090
		-DwxBUILD_PRECOMP="$(usex pch ON OFF)"
	)

	# With USE="X", we always build with the GLX GLCanvas because some software like
	# PrusaSlicer does not yet support EGL:
	#
	# https://github.com/prusa3d/PrusaSlicer/issues/9774 .
	#
	# A solution for this is being developed upstream:
	#
	# https://github.com/wxWidgets/wxWidgets/issues/22325 .
	#
	# Any software that needs to use OpenGL under Wayland can be patched like
	# this to run under xwayland:
	#
	# https://github.com/visualboyadvance-m/visualboyadvance-m/commit/aca206a721265366728222d025fec30ee500de82 .
	#
	# Check that the macro wxUSE_GLCANVAS_EGL is set to 1.
	#
	mycmakeargs+=( -DwxUSE_GLCANVAS_EGL="$(usex X OFF ON)" )

	# debug in >=2.9
	# there is no longer separate debug libraries (gtk2ud)
	# wxDEBUG_LEVEL=1 is the default and we will leave it enabled
	# wxDEBUG_LEVEL=2 enables assertions that have expensive runtime costs.
	# apps can disable these features by building w/ -NDEBUG or wxDEBUG_LEVEL_0.
	# http://docs.wxwidgets.org/3.0/overview_debugging.html
	# https://groups.google.com/group/wx-dev/browse_thread/thread/c3c7e78d63d7777f/05dee25410052d9c
	use debug && mycmakeargs+=( -DwxBUILD_DEBUG_LEVEL=1 )

	# wxGTK options
	#   wxUSE_GRAPHICS_CONTEXT=ON - needed for webkit, editra
	#   wxUSE_LIBGNOMEVFS=OFF - bug #203389
	(use X || use wayland) && mycmakeargs+=(
		-DwxUSE_GRAPHICS_CONTEXT=ON
		-DwxUSE_GTKPRINT=ON
		-DwxUSE_GUI=ON
		-DwxDEFAULT_TOOLKIT=gtk3
		-DwxUSE_LIBPNG=sys
		-DwxUSE_LIBJPEG=sys
		-DwxUSE_LIBMSPACK=ON
		-DwxUSE_NANOSVG=builtin

		-DwxUSE_LIBGNOMEVFS=OFF
		-DwxUSE_LIBSDL="$(usex sdl)"
		-DwxUSE_MEDIACTRL="$(usex gstreamer)"
		-DwxUSE_WEBVIEW="$(usex webkit)"
		-DwxUSE_LIBNOTIFY="$(usex libnotify)"
		-DwxUSE_OPENGL="$(usex opengl)"
		-DwxUSE_SPELLCHECK="$(usex spell)"
		# TODO: test_gui too with xvfb-run, as Fedora does?
		-DwxBUILD_TESTS="$(usex test CONSOLE_ONLY OFF)"
		-DwxUSE_UIACTIONSIMULATOR="$(usex X)"
		-DwxUSE_XTEST="$(usex X)"
	)

	# wxBase options
	! (use X || use wayland) && mycmakeargs+=( -DwxUSE_GUI=OFF )

	cmake_src_configure
}

multilib_src_install_all() {
	cd docs || die
	dodoc changes.txt readme.txt
	newdoc base/readme.txt base_readme.txt
	newdoc gtk/readme.txt gtk_readme.txt

	use doc && HTML_DOCS=( "${WORKDIR}"/wxWidgets-${PV}-docs-html/. )
	einstalldocs

	# Unversioned links
	rm "${ED}"/usr/bin/wx-config || die
	rm "${ED}"/usr/bin/wxrc || die
}

pkg_postinst() {
	has_version -b app-eselect/eselect-wxwidgets \
		&& eselect wxwidgets update
}

pkg_postrm() {
	has_version -b app-eselect/eselect-wxwidgets \
		&& eselect wxwidgets update
}
