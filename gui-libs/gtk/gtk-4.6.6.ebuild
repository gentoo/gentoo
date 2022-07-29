# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit gnome.org gnome2-utils meson optfeature python-any-r1 virtualx xdg

DESCRIPTION="GTK is a multi-platform toolkit for creating graphical user interfaces"
HOMEPAGE="https://www.gtk.org/ https://gitlab.gnome.org/GNOME/gtk/"

LICENSE="LGPL-2+"
SLOT="4"
IUSE="aqua broadway colord cups examples ffmpeg gstreamer +introspection sysprof test vulkan wayland +X cpu_flags_x86_f16c"
REQUIRED_USE="
	|| ( aqua wayland X )
	test? ( introspection )
"

KEYWORDS="~amd64 ~arm arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

COMMON_DEPEND="
	>=dev-libs/fribidi-0.19.7
	>=dev-libs/glib-2.66.0:2
	>=media-libs/graphene-1.9.1[introspection?]
	>=media-libs/libepoxy-1.4[egl,X(+)?]
	>=x11-libs/cairo-1.14[aqua?,glib,svg,X?]
	>=x11-libs/gdk-pixbuf-2.30:2[introspection?]
	>=x11-libs/pango-1.50.0[introspection?]
	media-libs/libpng:0=
	media-libs/tiff:0=
	media-libs/libjpeg-turbo:0=
	>=media-libs/harfbuzz-2.1.0:=
	x11-misc/shared-mime-info

	colord? ( >=x11-misc/colord-0.1.9:0= )
	cups? ( >=net-print/cups-2.0 )
	ffmpeg? ( media-video/ffmpeg )
	gstreamer? (
		>=media-libs/gst-plugins-bad-1.12.3
		>=media-libs/gst-plugins-base-1.12.3[opengl]
	)
	introspection? ( >=dev-libs/gobject-introspection-1.39:= )
	vulkan? ( media-libs/vulkan-loader:= )
	wayland? (
		>=dev-libs/wayland-1.20.0
		>=dev-libs/wayland-protocols-1.23
		media-libs/mesa[wayland]
		>=x11-libs/libxkbcommon-0.2
	)
	X? (
		>=app-accessibility/at-spi2-atk-2.5.3
		media-libs/fontconfig
		media-libs/mesa[X(+)]
		x11-libs/libX11
		>=x11-libs/libXi-1.8
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
	dev-libs/gobject-introspection-common
	introspection? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/pygobject:3[${PYTHON_USEDEP}]
		')
	)
	dev-python/docutils
	>=dev-util/gdbus-codegen-2.48
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	test? (
		dev-libs/glib:2
		wayland? ( dev-libs/weston[headless] )
	)
"

python_check_deps() {
	python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" || return
}

pkg_setup() {
	use introspection && python-any-r1_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset

	# dev-python/docutils installs rst2man.py, not rst2man
	sed -i -e "s/'rst2man'/'rst2man.py'/" docs/reference/gtk/meson.build || die
	# Nothing should use gtk4-update-icon-cache and an unversioned one is shipped by dev-util/gtk-update-icon-cache
	sed -i -e '/gtk4-update-icon-cache/d' tools/meson.build || die
	# Workaround RWX ELF sections, https://gitlab.gnome.org/GNOME/gtk/-/issues/4598
	sed -i -e 's/^ld =.*/ld = disabler()/g' gtk/meson.build demos/gtk-demo/meson.build demos/widget-factory/meson.build || die
	sed -i -e 's/^objcopy =.*/objcopy = disabler()/g' gtk/meson.build demos/gtk-demo/meson.build demos/widget-factory/meson.build || die
}

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
		-Dgtk_doc=false # we ship pregenerated API docs from tarball
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

	insinto /usr/share/gtk-doc/html
	# This will install API docs specific to X11 and wayland regardless of USE flags, but this is intentional
	doins -r "${S}"/docs/reference/{gtk/gtk4,gsk/gsk4,gdk/gdk4{,-wayland,-x11}}
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
