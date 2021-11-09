# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson optfeature virtualx xdg

DESCRIPTION="GTK is a multi-platform toolkit for creating graphical user interfaces"
HOMEPAGE="https://www.gtk.org/ https://gitlab.gnome.org/GNOME/gtk/"

LICENSE="LGPL-2+"
SLOT="4"
IUSE="aqua broadway colord cups examples ffmpeg gstreamer gtk-doc +introspection sysprof test vulkan wayland +X cpu_flags_x86_f16c"
REQUIRED_USE="
	|| ( aqua wayland X )
	gtk-doc? ( introspection )
	test? ( introspection )
"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

COMMON_DEPEND="
	>=dev-libs/fribidi-0.19.7
	>=dev-libs/glib-2.66.0:2
	>=media-libs/graphene-1.9.1[introspection?]
	>=media-libs/libepoxy-1.4[X(+)?]
	>=x11-libs/cairo-1.14[aqua?,glib,svg,X?]
	>=x11-libs/gdk-pixbuf-2.30:2[introspection?]
	>=x11-libs/pango-1.47.0[introspection?]
	>=media-libs/harfbuzz-2.1.0:=
	x11-misc/shared-mime-info

	colord? ( >=x11-misc/colord-0.1.9:0= )
	cups? ( >=net-print/cups-2.0 )
	ffmpeg? ( media-video/ffmpeg )
	gstreamer? ( >=media-libs/gst-plugins-bad-1.12.3 )
	introspection? ( >=dev-libs/gobject-introspection-1.39:= )
	vulkan? ( media-libs/vulkan-loader:= )
	wayland? (
		>=dev-libs/wayland-1.16.91
		>=dev-libs/wayland-protocols-1.21
		media-libs/mesa[wayland]
		>=x11-libs/libxkbcommon-0.2
	)
	X? (
		>=app-accessibility/at-spi2-atk-2.5.3
		media-libs/fontconfig
		media-libs/mesa[X(+)]
		x11-libs/libX11
		>=x11-libs/libXi-1.3
		x11-libs/libXext
		>=x11-libs/libXrandr-1.5
		x11-libs/libXcursor
		x11-libs/libXfixes
		x11-libs/libXdamage
		x11-libs/libXinerama
	)
"
DEPEND="${COMMON_DEPEND}
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4 )
	X? ( x11-base/xorg-proto )
"
RDEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-update-icon-cache-3
"
# librsvg for svg icons (PDEPEND to avoid circular dep), bug #547710
PDEPEND="
	gnome-base/librsvg
	>=x11-themes/adwaita-icon-theme-3.14
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/gobject-introspection-common
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.48
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	gtk-doc? (
		app-text/docbook-xml-dtd:4.3
		dev-util/gi-docgen
	)
	test? (
		dev-libs/glib:2
		wayland? ( dev-libs/weston[headless] )

		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc
	)
"

src_configure() {
	local emesonargs=(
		# GDK backends
		$(meson_use X x11-backend)
		$(meson_use wayland wayland-backend)
		$(meson_use broadway broadway-backend)
		-Dwin32-backend=false
		$(meson_use aqua macos-backend)

		# Media backends
		$(meson_feature ffmpeg media-ffmpeg)
		$(meson_feature gstreamer media-gstreamer)

		# Print backends
		$(meson_feature cups print-cups)

		# Optional dependencies
		$(meson_feature vulkan)
		-Dcloudproviders=disabled  # cloudprovider is not packaged in Gentoo yet
		$(meson_feature sysprof)
		-Dtracker=disabled  # tracker3 is not packaged in Gentoo yet
		$(meson_feature colord)
		# Expected to fail with GCC < 11
		# See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=71993
		$(meson_feature cpu_flags_x86_f16c f16c)

		# Documentation and introspection
		$(meson_use gtk-doc gtk_doc)
		-Dman-pages=true
		$(meson_feature introspection)

		# Demos and binaries
		$(meson_use examples build-examples)
		$(meson_use examples demos)
		$(meson_use test build-tests)
		-Dinstall-tests=false
	)
	meson_src_configure
}

src_test() {
	"${BROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/gtk" || die

	if use X; then
		einfo "Running tests under X"
		GSETTINGS_SCHEMA_DIR="${S}/gtk" virtx meson_src_test --setup=x11
	fi

	if use wayland; then
		einfo "Running tests under Weston"

		export XDG_RUNTIME_DIR="$(mktemp -p $(pwd) -d xdg-runtime-XXXXXX)"

		weston --backend=headless-backend.so --socket=wayland-5 --idle-time=0 &
		compositor=$!
		export WAYLAND_DISPLAY=wayland-5

		GSETTINGS_SCHEMA_DIR="${S}/gtk" meson_src_test --setup=wayland

		exit_code=$?
		kill ${compositor}
	fi
}

src_install() {
	meson_src_install

	if use gtk-doc ; then
		mkdir "${ED}"/usr/share/doc/${PF}/html || die

		local docdirs=( gdk4 gsk4 gtk4 )
		use wayland && docdirs+=( gdk4-wayland )
		use X && docdirs+=( gdk4-x11 )

		local d
		for d in "${docdirs[@]}"; do
			mv "${ED}"/usr/share/doc/{${d},${PF}/html/} || die
		done
	fi
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if ! has_version "app-text/evince"; then
		elog "Please install app-text/evince for print preview functionality."
		elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
		elog "add it to your settings.ini file."
	fi

	if use examples ; then
		optfeature "syntax highlighting in gtk4-demo" app-text/highlight
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
