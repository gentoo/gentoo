# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2 meson-multilib multilib toolchain-funcs virtualx

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="3"
IUSE="aqua broadway cloudproviders colord cups examples gtk-doc +introspection sysprof test vim-syntax wayland +X xinerama"
REQUIRED_USE="
	|| ( aqua wayland X )
	test? ( X )
	xinerama? ( X )
"
RESTRICT="!test? ( test )"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.46.0[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/fribidi-0.19.7[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.57.2:2[${MULTILIB_USEDEP}]
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.2.0:=
	>=media-libs/libepoxy-1.4[X(+)?,egl(+),${MULTILIB_USEDEP}]
	virtual/libintl[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.14[aqua?,glib,svg(+),X?,${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.30:2[introspection?,${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.44.0[introspection?,${MULTILIB_USEDEP}]
	x11-misc/shared-mime-info

	cloudproviders? ( net-libs/libcloudproviders[${MULTILIB_USEDEP}] )
	colord? ( >=x11-misc/colord-0.1.9:0=[${MULTILIB_USEDEP}] )
	cups? ( >=net-print/cups-2.0[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.39:= )
	sysprof? ( >=dev-util/sysprof-capture-3.33.2:3[${MULTILIB_USEDEP}] )
	wayland? (
		>=dev-libs/wayland-1.14.91[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.32
		media-libs/mesa[wayland,${MULTILIB_USEDEP}]
		>=x11-libs/libxkbcommon-0.2[${MULTILIB_USEDEP}]
	)
	X? (
		media-libs/libglvnd[X(+),${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXcomposite[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXdamage[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.8[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.5[${MULTILIB_USEDEP}]
		xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${COMMON_DEPEND}
	X? ( x11-base/xorg-proto )
"
RDEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-update-icon-cache-3
"
# librsvg for svg icons (PDEPEND to avoid circular dep), bug #547710
PDEPEND="
	gnome-base/librsvg[${MULTILIB_USEDEP}]
	>=x11-themes/adwaita-icon-theme-3.14
	vim-syntax? ( app-vim/gtk-syntax )
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/gobject-introspection-common
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.48
	dev-util/glib-utils
	>=dev-build/gtk-doc-am-1.20
	wayland? ( dev-util/wayland-scanner )
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	x11-libs/gdk-pixbuf:2
	gtk-doc? (
		app-text/docbook-xml-dtd:4.3
		>=dev-util/gtk-doc-1.20
	)
	test? ( sys-apps/dbus )
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gtk-query-immodules-3.0$(get_exeext)
)

PATCHES=(
	# gtk-update-icon-cache is installed by dev-util/gtk-update-icon-cache
	"${FILESDIR}"/${PN}-3.24.36-update-icon-cache.patch
	# Gentoo-specific patch to add a "poison" macro support, allowing other ebuilds
	# with USE="-wayland -X" to trick gtk into claiming that it wasn't built with
	# such support.
	# https://bugs.gentoo.org/624960
	"${FILESDIR}"/0001-gdk-add-a-poison-macro-to-hide-GDK_WINDOWING_.patch
)

src_prepare() {
	default

	# The border-image-excess-size.ui test is known to fail on big-endian platforms
	# See https://gitlab.gnome.org/GNOME/gtk/-/issues/5904
	if [[ $(tc-endian) == big ]]; then
		sed -i \
			-e "/border-image-excess-size.ui/d" \
			-e "/^xfails =/a 'border-image-excess-size.ui'," \
			testsuite/reftests/meson.build || die
	fi
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_use aqua quartz_backend)
		$(meson_use broadway broadway_backend)
		$(meson_use cloudproviders)
		$(meson_use examples demos)
		$(meson_use examples)
		$(meson_native_use_bool gtk-doc gtk_doc)
		$(meson_native_use_bool introspection)
		$(meson_use sysprof profiler)
		$(meson_use wayland wayland_backend)
		$(meson_use X x11_backend)
		-Dcolord=$(usex colord yes no)
		-Dprint_backends=$(usex cups cups,file,lpr file,lpr)
		-Dxinerama=$(usex xinerama yes no)
		# Include backend immodules into gtk itself, to avoid problems like
		# https://gitlab.gnome.org/GNOME/gnome-shell/issues/109 from a
		# user overridden GTK_IM_MODULE envvar
		-Dbuiltin_immodules=backend
		-Dman=true
		$(meson_use test tests)
		-Dtracker3=false
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	virtx dbus-run-session meson test -C "${BUILD_DIR}" --timeout-multiplier 4 || die
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	insinto /etc/gtk-3.0
	doins "${FILESDIR}"/settings.ini
	# Skip README.win32.md that would get installed by default
	DOCS=( NEWS README.md )
	einstalldocs
}

pkg_preinst() {
	gnome2_pkg_preinst

	multilib_pkg_preinst() {
		# Make immodules.cache belongs to gtk+ alone
		local cache="/usr/$(get_libdir)/gtk-3.0/3.0.0/immodules.cache"

		if [[ -e ${EROOT}${cache} ]]; then
			cp "${EROOT}${cache}" "${ED}${cache}" || die
		else
			touch "${ED}${cache}" || die
		fi
	}
	multilib_parallel_foreach_abi multilib_pkg_preinst
}

pkg_postinst() {
	gnome2_pkg_postinst

	multilib_pkg_postinst() {
		gnome2_query_immodules_gtk3 \
			|| die "Update immodules cache failed (for ${ABI})"
	}
	multilib_parallel_foreach_abi multilib_pkg_postinst

	if ! has_version "app-text/evince"; then
		elog "Please install app-text/evince for print preview functionality."
		elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
		elog "add it to your settings.ini file."
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm

	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		multilib_pkg_postrm() {
			rm -f "${EROOT}/usr/$(get_libdir)/gtk-3.0/3.0.0/immodules.cache"
		}
		multilib_foreach_abi multilib_pkg_postrm
	fi
}
