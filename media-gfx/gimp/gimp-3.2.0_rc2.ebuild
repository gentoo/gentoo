# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{11..14} )
VALA_USE_DEPEND=vapigen

inherit flag-o-matic lua-single meson python-single-r1 toolchain-funcs vala xdg

DESCRIPTION="GNU Image Manipulation Program"
HOMEPAGE="https://www.gimp.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gimp.git"

	MAJOR_VERSION="3"
else
	MY_PV="${PV/_rc/-RC}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="mirror://gimp/v$(ver_cut 1-2)/${MY_P}.tar.xz"
	S="${WORKDIR}/${MY_P}"

	MAJOR_VERSION="$(ver_cut 1)"

	# Dont keyword prereleases or unstable releases
	# https://gitlab.gnome.org/Infrastructure/gimp-web-devel/-/blob/testing/content/core/maintainer/versioning.md#software-version
	if ! [[ ${PV} =~ _rc ]] &&
		[[ $(( $(ver_cut 2) % 2 )) -eq 0 ]] &&
		[[ $(( $(ver_cut 3) % 2 )) -eq 0 ]]
	then
		KEYWORDS="~amd64 ~arm ~x86"
	fi
fi

LICENSE="GPL-3+ LGPL-3+"
SLOT="0/${MAJOR_VERSION}"

IUSE="X aalib alsa doc fits gnome heif javascript jpeg2k jpegxl lua mng openexr openmp postscript test udev unwind vala vector-icons wayland webp wmf xpm"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	lua? ( ${LUA_REQUIRED_USE} )
	test? ( X )
	xpm? ( X )
"

RESTRICT="!test? ( test )"

# automagic dependency on bash to create bash-completions

# media-libs/{babl,gegl} are required to be built with USE="introspection"
# to fix the compilation checking of /usr/share/gir-1.0/{Babl-0.1gir,Gegl-0.4.gir}
COMMON_DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/pygobject-3.0:3[${PYTHON_USEDEP}]
	')
	>=app-accessibility/at-spi2-core-2.4.0
	app-arch/bzip2
	app-arch/libarchive:=
	>=app-arch/xz-utils-5.0.0
	app-text/iso-codes
	>=app-text/poppler-0.69.0[cairo]
	>=app-text/poppler-data-0.4.9
	>=dev-libs/appstream-0.16.1:=
	>=dev-libs/glib-2.70.0:2
	>=dev-libs/gobject-introspection-1.82.0-r2
	>=dev-libs/json-glib-1.2.6
	>=gnome-base/librsvg-2.40.6:2
	>=media-gfx/exiv2-0.27.4
	media-gfx/mypaint-brushes:2.0=
	>=media-libs/fontconfig-2.12.4
	>=media-libs/freetype-2.1.7
	<media-libs/gexiv2-0.15.0
	>=media-libs/gexiv2-0.14.0
	>=media-libs/harfbuzz-2.8.2:=
	>=media-libs/lcms-2.8:2
	media-libs/libjpeg-turbo:=
	>=media-libs/libmypaint-1.5.0:=
	>=media-libs/libpng-1.6.25:0=
	>=media-libs/tiff-4.0.0:=
	net-libs/glib-networking[ssl]
	virtual/zlib:=
	>=x11-libs/cairo-1.14.0[X?]
	>=x11-libs/gdk-pixbuf-2.30.8:2[introspection]
	>=x11-libs/gtk+-3.24.0:3[introspection,wayland?,X?]
	>=x11-libs/pango-1.50.0[X?]
	aalib? ( media-libs/aalib )
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	fits? ( sci-libs/cfitsio:= )
	heif? ( >=media-libs/libheif-1.15.1:= )
	javascript? ( dev-libs/gjs )
	jpeg2k? ( >=media-libs/openjpeg-2.1.0:2= )
	jpegxl? ( >=media-libs/libjxl-0.7.0:= )
	lua? (
		${LUA_DEPS}
		$(lua_gen_cond_dep '
			dev-lua/lgi[${LUA_USEDEP}]
		')
	)
	mng? ( media-libs/libmng:= )
	openexr? ( >=media-libs/openexr-1.6.1:= )
	postscript? ( app-text/ghostscript-gpl:= )
	udev? ( >=dev-libs/libgudev-167:= )
	unwind? ( >=sys-libs/libunwind-1.1.0:= )
	webp? ( >=media-libs/libwebp-0.6.0:= )
	wmf? ( >=media-libs/libwmf-0.2.8[X?] )
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXfixes
		>=x11-libs/libXmu-1.1.4
	)
	xpm? ( x11-libs/libXpm )
"
if [[ ${PV} == 9999 ]]; then
	COMMON_DEPEND+="
		>=media-libs/babl-9999[introspection,lcms,vala?]
		>=media-libs/gegl-9999[cairo,introspection,lcms,vala?]
	"
else
	COMMON_DEPEND+="
		>=media-libs/babl-0.1.118[introspection,lcms,vala?]
		>=media-libs/gegl-0.4.66:0.4[cairo,introspection,lcms,vala?]
	"
fi

RDEPEND="
	${COMMON_DEPEND}
	x11-themes/hicolor-icon-theme
	gnome? ( gnome-base/gvfs )
"

DEPEND="${COMMON_DEPEND}"

BDEPEND="
	>=dev-lang/perl-5.30.3
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.80.5-r1
	>=sys-devel/gettext-0.21
	virtual/pkgconfig
	doc? (
		>=dev-libs/gobject-introspection-1.82.0-r2[doctool]
		dev-util/gi-docgen
	)
	test? (
		sys-apps/dbus
		x11-misc/xvfb-run
	)
	vala? ( $(vala_depend) )
	vector-icons? ( x11-misc/shared-mime-info )
"

DOCS=( "AUTHORS" "NEWS" "README" "README.i18n" )

PATCHES=(
	"${FILESDIR}"/gimp-3.0.6-fix-tests.patch
	"${FILESDIR}"/gimp-3.0.6-respect-NM.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	python-single-r1_pkg_setup
	use lua && lua-single_pkg_setup

	if has_version ">=media-libs/babl-9999" || has_version ">=media-libs/gegl-9999"; then
		ewarn "Please make sure to rebuild media-libs/babl-9999 and media-libs/gegl-9999 packages"
		ewarn "before building media-gfx/gimp-9999 to have their latest master branch versions."
	fi
}

src_prepare() {
	default

	# Fix Gimp  and GimpUI devel doc installation paths
	sed -i -e "s/'doc'/'gtk-doc'/" devel-docs/reference/gimp/meson.build || die
	sed -i -e "s/'doc'/'gtk-doc'/" devel-docs/reference/gimp-ui/meson.build || die

	# Fix pygimp.interp python implementation path.
	# Meson @PYTHON_PATH@ use sandbox path e.g.:
	# '/var/tmp/portage/media-gfx/gimp-2.99.12/temp/python3.10/bin/python3'
	sed -i -e 's/@PYTHON_EXE@/'${EPYTHON}'/' plug-ins/python/pygimp.interp.in || die

	# Set proper intallation path of documentation logo
	sed -i -e "s/'gimp-@0@'.format(gimp_app_version)/'gimp-${PVR}'/" gimp-data/images/logo/meson.build || die

	# Force disable x11_target if USE="-X" is setup. See bug 943164 for additional info
	use !X && { sed -i -e 's/x11_target = /x11_target = false #/' meson.build || die; }
}

src_configure() {
	# defang automagic dependencies. Bug 943164
	use wayland || append-cppflags -DGENTOO_GTK_HIDE_WAYLAND
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11

	use vala && vala_setup

	local emesonargs=(
		-Denable-default-bin=enabled

		-Dcheck-update=no
		-Ddebug-self-in-build=false
		-Denable-multiproc=true
		-Dappdata-test=disabled
		-Dbug-report-url=https://bugs.gentoo.org/
		-Dilbm=disabled
		-Dlibbacktrace=false
		-Dwebkit-unmaintained=false
		$(meson_feature aalib aa)
		$(meson_feature alsa)
		$(meson_feature doc gi-docgen)
		$(meson_feature fits)
		$(meson_feature heif)
		$(meson_feature javascript)
		$(meson_feature jpeg2k jpeg2000)
		$(meson_feature jpegxl jpeg-xl)
		$(meson_feature mng)
		$(meson_feature openexr)
		$(meson_feature openmp)
		$(meson_feature postscript ghostscript)
		$(meson_feature test headless-tests)
		$(meson_feature udev gudev)
		$(meson_feature vala)
		$(meson_feature webp)
		$(meson_feature wmf)
		$(meson_feature X xcursor)
		$(meson_feature xpm)
		$(meson_use lua)
		$(meson_use unwind libunwind)
		$(meson_use vector-icons)
	)

	meson_src_configure
}

src_compile() {
	export XDG_DATA_DIRS="${EPREFIX}"/usr/share  # bug 587004
	meson_src_compile
}

# for https://bugs.gentoo.org/664938
_rename_plugins() {
	einfo 'Renaming plug-ins to not collide with pre-2.10.6 file layout (bug #664938)...'
	local prename=gimp-org-
	(
		cd "${ED}"/usr/$(get_libdir)/gimp/3.0/plug-ins || exit 1
		for plugin_slash in $(ls -d1 */); do
			plugin=${plugin_slash%/}
			if [[ -f ${plugin}/${plugin} ]]; then
				# NOTE: Folder and file name need to match for Gimp to load that plug-in
				#       so "file-svg/file-svg" becomes "${prename}file-svg/${prename}file-svg"
				mv ${plugin}/{,${prename}}${plugin} || exit 1
				mv {,${prename}}${plugin} || exit 1
			fi
		done
	)
}

src_test() {
	local -x LD_LIBRARY_PATH="${BUILD_DIR}/libgimp:${LD_LIBRARY_PATH}"
	# Try hard to avoid system installed gimp causing issues
	local -x GIMP3_DIRECTORY="${BUILD_DIR}/"
	local -x GIMP3_PLUGINDIR="${BUILD_DIR}/plug-ins/"
	local -x GIMP3_SYSCONFDIR="${BUILD_DIR}/etc/"
	meson_src_test
}

src_install() {
	meson_src_install

	python_optimize "${ED}/usr/$(get_libdir)/gimp"
	python_fix_shebang "${ED}/usr/$(get_libdir)/gimp"

	# Create symlinks for Gimp exec in /usr/bin
	# gimp-$(ver_cut 1-2) -> gimp-$(ver_cut 1) -> gimp
	dosym "${ESYSROOT}"/usr/bin/gimp-${MAJOR_VERSION} /usr/bin/gimp
	dosym "${ESYSROOT}"/usr/bin/gimp-console-${MAJOR_VERSION} /usr/bin/gimp-console
	dosym "${ESYSROOT}"/usr/bin/gimp-script-fu-interpreter-${MAJOR_VERSION} /usr/bin/gimp-script-fu-interpreter
	dosym "${ESYSROOT}"/usr/bin/gimp-test-clipboard-${MAJOR_VERSION} /usr/bin/gimp-test-clipboard
	dosym "${ESYSROOT}"/usr/bin/gimptool-${MAJOR_VERSION} /usr/bin/gimptool

	_rename_plugins || die
}
