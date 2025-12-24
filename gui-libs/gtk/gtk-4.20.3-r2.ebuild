# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )
inherit flag-o-matic gnome.org gnome2-utils meson optfeature python-any-r1 toolchain-funcs virtualx xdg

DESCRIPTION="GTK is a multi-platform toolkit for creating graphical user interfaces"
HOMEPAGE="https://www.gtk.org/ https://gitlab.gnome.org/GNOME/gtk/"

LICENSE="LGPL-2+"
SLOT="4"
REQUIRED_USE="
	|| ( aqua wayland X )
	gtk-doc? ( introspection )
	test? ( introspection )
"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="aqua broadway cloudproviders colord cups examples gstreamer gtk-doc +introspection sysprof test vulkan wayland +X cpu_flags_x86_f16c"

# librsvg for svg icons and "!8541 Use librsvg for symbolics that we
#     can't parse ourselves" (formerly a PDEPEND to avoid circular dep
#     on wd40 profiles with librsvg[tools]), bug #547710
# NOTE: Support was added to build against both cups2 and cups3
COMMON_DEPEND="
	>=dev-libs/glib-2.82:2
	>=x11-libs/cairo-1.18.2[aqua?,glib,svg(+),X?]
	>=x11-libs/pango-1.56.0[introspection?]
	>=dev-libs/fribidi-1.0.6
	>=media-libs/harfbuzz-8.4.0:=
	>=x11-libs/gdk-pixbuf-2.30:2[introspection?]
	media-libs/libpng:=
	media-libs/tiff:=
	media-libs/libjpeg-turbo:=
	>=gnome-base/librsvg-2.48:2
	>=media-libs/libepoxy-1.4[egl(+),X(+)?]
	>=media-libs/graphene-1.10.0[introspection?]
	app-text/iso-codes
	x11-misc/shared-mime-info

	cloudproviders? ( net-libs/libcloudproviders )
	colord? ( >=x11-misc/colord-0.1.9:0= )
	cups? ( >=net-print/cups-2.0 )
	examples? ( gnome-base/librsvg:2 )
	gstreamer? (
		>=media-libs/gstreamer-1.24.0:1.0
		>=media-libs/gst-plugins-bad-1.24.0:1.0
		|| (
			>=media-libs/gst-plugins-base-1.24.0:1.0[gles2]
			>=media-libs/gst-plugins-base-1.24.0:1.0[opengl]
		)
	)
	introspection? ( >=dev-libs/gobject-introspection-1.84:= )
	vulkan? (
		>=media-libs/vulkan-loader-1.3:=[wayland?,X?]
		media-libs/mesa[vulkan]
		)
	wayland? (
		>=dev-libs/wayland-1.24.0
		>=dev-libs/wayland-protocols-1.44
		media-libs/mesa[wayland]
		>=x11-libs/libxkbcommon-0.2
	)
	X? (
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
	kernel_linux? (
		x11-libs/libdrm
		sys-kernel/linux-headers
	)
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4 )
	X? ( x11-base/xorg-proto )
"
RDEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-update-icon-cache-3
"
PDEPEND="
	>=x11-themes/adwaita-icon-theme-3.14
"
BDEPEND="
	>=dev-build/meson-1.5.0
	dev-libs/gobject-introspection-common
	introspection? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/pygobject:3[${PYTHON_USEDEP}]
		')
	)
	dev-python/docutils
	>=dev-libs/glib-2.82
	>=dev-util/gdbus-codegen-2.48
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
	vulkan? ( media-libs/shaderc )
	wayland? (
		>=dev-util/wayland-scanner-1.24.0
	)
	test? (
		dev-libs/glib:2
		media-fonts/cantarell
		wayland? ( dev-libs/weston[headless] )
	)
"

PATCHES=(
	# Gentoo-specific patch to add a "poison" macro support, allowing other ebuilds
	# with USE="-wayland -X" to trick gtk into claiming that it wasn't built with
	# such support.
	# https://bugs.gentoo.org/624960
	"${FILESDIR}"/0001-gdk-add-a-poison-macro-to-hide-GDK_WINDOWING_ge_4.18.5.patch

	"${FILESDIR}"/${P}-32-bit.patch
)

python_check_deps() {
	python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" || return
}

pkg_setup() {
	use introspection && python-any-r1_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset

	# Nothing should use gtk4-update-icon-cache and an unversioned one is shipped by dev-util/gtk-update-icon-cache
	sed -i \
		-e '/gtk4-update-icon-cache/d' \
		docs/reference/gtk/meson.build \
		tools/meson.build \
		|| die

	# The border-image-excess-size.ui test is known to fail on big-endian platforms
	# See https://gitlab.gnome.org/GNOME/gtk/-/issues/5904
	if [[ $(tc-endian) == big ]]; then
		sed -i \
			-e "/border-image-excess-size.ui/d" \
			-e "/^xfails =/a 'border-image-excess-size.ui'," \
			testsuite/reftests/meson.build || die
	fi
}

src_configure() {
	use x86 && append-flags -DDISABLE_X64=1 #943705 https://gitlab.gnome.org/GNOME/gtk/-/issues/4173

	local emesonargs=(
		# GDK backends
		$(meson_use X x11-backend)
		$(meson_use wayland wayland-backend)
		$(meson_use broadway broadway-backend)
		-Dwin32-backend=false
		-Dandroid-backend=false
		$(meson_use aqua macos-backend)

		# Media backends
		$(meson_feature gstreamer media-gstreamer)

		# Print backends
		-Dprint-cpdb=disabled
		$(meson_feature cups print-cups)

		# Optional dependencies
		$(meson_feature vulkan)
		$(meson_feature cloudproviders)
		$(meson_feature sysprof)
		-Dtracker=disabled  # tracker3 is not packaged in Gentoo yet
		$(meson_feature colord)
		# Expected to fail with GCC < 11
		# See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=71993
		$(meson_feature cpu_flags_x86_f16c f16c)
		-Dandroid-runtime=disabled
		# Introspection
		$(meson_feature introspection)

		# Documentation
		$(meson_use gtk-doc documentation)
		-Dscreenshots=false
		-Dman-pages=true

		# Demos, examples, and tests
		-Dprofile=default
		$(meson_use examples build-demos)
		$(meson_use test build-testsuite)
		$(meson_use examples build-examples)
		-Dbuild-tests=false
	)
	meson_src_configure
}

src_test() {
	"${BROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/gtk" || die

	addwrite /dev/dri

	# Note that skipping gsk-compare entirely means we do run *far*
	# fewer tests, but a reliable testsuite for us is more important
	# than absolute-maximum coverage if we can't trust the results and
	# dismiss any failures as "probably font related" and so on.
	if use X; then
		einfo "Running tests under X"
		GSETTINGS_SCHEMA_DIR="${S}/gtk" virtx meson_src_test --timeout-multiplier=130 \
			--setup=x11 \
			--no-suite=failing \
			--no-suite=x11_failing \
			--no-suite=flaky \
			--no-suite=headless \
			--no-suite=gsk-compare \
			--no-suite=gsk-compare-broadway \
			--no-suite=needs-udmabuf \
			--no-suite=pango
	fi

	if use wayland; then
		einfo "Running tests under Weston"

		export XDG_RUNTIME_DIR="$(mktemp -p $(pwd) -d xdg-runtime-XXXXXX)"

		weston --backend=headless-backend.so --socket=wayland-5 --idle-time=0 &
		compositor=$!
		export WAYLAND_DISPLAY=wayland-5

		GSETTINGS_SCHEMA_DIR="${S}/gtk" meson_src_test --timeout-multiplier=130 \
			--setup=wayland \
			--no-suite=failing \
			--no-suite=wayland_failing \
			--no-suite=flaky \
			--no-suite=headless \
			--no-suite=gsk-compare \
			--no-suite=gsk-compare-broadway \
			--no-suite=needs-udmabuf

		exit_code=$?
		kill ${compositor}
	fi
}

src_install() {
	local i src

	meson_src_install

	if use gtk-doc; then
		mkdir -p "${ED}/usr/share/gtk-doc/html" || die

		for dir in gdk4 gtk4 gsk4; do
			src="${ED}/usr/share/doc/${dir}"
			test -d "${src}" || die "Expected documentation directory ${src} not found"
			mv -v "${src}" "${ED}/usr/share/gtk-doc/html" || die
		done

		if use X; then
			src="${ED}/usr/share/doc/gdk4-x11"
			test -d "${src}" || die "Expected X11 documentation ${src} not found"
			mv -v "${src}" "${ED}/usr/share/gtk-doc/html" || die
		fi

		if use wayland; then
			src="${ED}/usr/share/doc/gdk4-wayland"
			test -d "${src}" || die "Expected Wayland documentation ${src} not found"
			mv -v "${src}" "${ED}/usr/share/gtk-doc/html" || die
		fi
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
