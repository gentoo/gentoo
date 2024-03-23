# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{10..11} )
VALA_USE_DEPEND=vapigen

inherit lua-single meson python-single-r1 toolchain-funcs vala xdg

DESCRIPTION="GNU Image Manipulation Program"
HOMEPAGE="https://www.gimp.org/"
SRC_URI="mirror://gimp/v$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0/3"

IUSE="X aalib alsa doc gnome heif javascript jpeg2k jpegxl lua mng openexr openmp postscript python test udev unwind vala vector-icons webp wmf xpm"
REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
"

RESTRICT="!test? ( test )"

# media-libs/{babl,gegl} are required to be built with USE="introspection"
# to fix the compilation checking of /usr/share/gir-1.0/{Babl-0.1gir,Gegl-0.4.gir}
COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.46.0
	>=app-text/poppler-0.90.1[cairo]
	>=app-text/poppler-data-0.4.9
	>=dev-libs/appstream-glib-0.7.16
	>=dev-libs/glib-2.70.0:2
	>=dev-libs/json-glib-1.4.4
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=gnome-base/librsvg-2.46.0:2
	>=media-gfx/mypaint-brushes-2.0.2:=
	>=media-libs/babl-0.1.98[introspection,lcms,vala?]
	>=media-libs/fontconfig-2.12.6
	>=media-libs/freetype-2.10.2
	>=media-libs/gegl-0.4.48:0.4[cairo,introspection,lcms,vala?]
	>=media-libs/gexiv2-0.14.0
	>=media-libs/harfbuzz-2.6.5:=
	>=media-libs/lcms-2.13.1:2
	media-libs/libjpeg-turbo:=
	>=media-libs/libmypaint-1.6.1:=
	>=media-libs/libpng-1.6.37:0=
	>=media-libs/tiff-4.1.0:=
	net-libs/glib-networking[ssl]
	sys-libs/zlib
	>=x11-libs/cairo-1.16.0
	>=x11-libs/gdk-pixbuf-2.40.0:2[introspection]
	>=x11-libs/gtk+-3.24.16:3[introspection]
	>=x11-libs/pango-1.50.0
	>=x11-libs/libXmu-1.1.4
	aalib? ( media-libs/aalib )
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	heif? ( >=media-libs/libheif-1.13.0:= )
	javascript? ( dev-libs/gjs )
	jpeg2k? ( >=media-libs/openjpeg-2.3.1:2= )
	jpegxl? ( >=media-libs/libjxl-0.6.1:= )
	lua? (
		${LUA_DEPS}
		$(lua_gen_cond_dep '
			dev-lua/lgi[${LUA_USEDEP}]
		')
	)
	mng? ( media-libs/libmng:= )
	openexr? ( >=media-libs/openexr-2.3.0:= )
	postscript? ( app-text/ghostscript-gpl:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/pygobject-3.0:3[${PYTHON_USEDEP}]
		')
	)
	udev? ( >=dev-libs/libgudev-167:= )
	unwind? ( >=sys-libs/libunwind-1.1.0:= )
	webp? ( >=media-libs/libwebp-0.6.0:= )
	wmf? ( >=media-libs/libwmf-0.2.8 )
	X? ( x11-libs/libXcursor )
	xpm? ( x11-libs/libXpm )
"

RDEPEND="
	${COMMON_DEPEND}
	x11-themes/hicolor-icon-theme
	gnome? ( gnome-base/gvfs )
"

DEPEND="
	${COMMON_DEPEND}
	test? ( x11-misc/xvfb-run )
	vala? ( $(vala_depend) )
"

# TODO: there are probably more atoms in DEPEND which should be in BDEPEND now
BDEPEND="
	>=dev-lang/perl-5.30.3
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.21
	doc? (
		app-text/yelp-tools
		dev-libs/gobject-introspection[doctool]
		dev-util/gi-docgen
	)
	virtual/pkgconfig
"

DOCS=( "AUTHORS" "NEWS" "README" "README.i18n" )

PATCHES=(
	"${FILESDIR}/${PN}-2.10_fix_musl_backtrace_backend_switch.patch" #900148
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	use lua && lua-single_pkg_setup

	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	default

	sed -i -e 's/mypaint-brushes-1.0/mypaint-brushes-2.0/' meson.build || die #737794

	# Fix Gimp  and GimpUI devel doc installation paths
	sed -i -e "s/'doc'/'gtk-doc'/" devel-docs/reference/gimp/meson.build || die
	sed -i -e "s/'doc'/'gtk-doc'/" devel-docs/reference/gimp-ui/meson.build || die

	# Fix pygimp.interp python implementation path.
	# Meson @PYTHON_PATH@ use sandbox path e.g.:
	# '/var/tmp/portage/media-gfx/gimp-2.99.12/temp/python3.10/bin/python3'
	sed -i -e 's/@PYTHON_PATH@/'${EPYTHON}'/' plug-ins/python/pygimp.interp.in || die

	# Set proper intallation path of documentation logo
	sed -i -e "s/'gimp-@0@'.format(gimp_app_version)/'gimp-${PVR}'/" data/images/meson.build || die
}

_adjust_sandbox() {
	# Bugs #569738 and #591214
	local nv
	for nv in /dev/nvidia-uvm /dev/nvidiactl /dev/nvidia{0..9} ; do
		# We do not check for existence as they may show up later
		# https://bugs.gentoo.org/show_bug.cgi?id=569738#c21
		addwrite "${nv}"
	done

	addwrite /dev/dri/  # bugs #574038 and #684886
	addwrite /dev/ati/  # bug #589198
	addwrite /proc/mtrr  # bug #589198
}

src_configure() {
	_adjust_sandbox

	use vala && vala_setup

	local emesonargs=(
		-Denable-default-bin=enabled

		-Dcheck-update=no
		-Denable-multiproc=true
		-Dappdata-test=disabled
		-Dbug-report-url=https://bugs.gentoo.org/
		-Dlibbacktrace=false
		-Dwebkit-unmaintained=false
		$(meson_feature aalib aa)
		$(meson_feature alsa)
		$(meson_feature doc gi-docgen)
		$(meson_feature heif)
		$(meson_feature javascript)
		$(meson_feature jpeg2k jpeg2000)
		$(meson_feature jpegxl jpeg-xl)
		$(meson_feature lua)
		$(meson_feature mng)
		$(meson_feature openexr)
		$(meson_feature openmp)
		$(meson_feature postscript ghostscript)
		$(meson_feature python)
		$(meson_feature test headless-tests)
		$(meson_feature udev gudev)
		$(meson_feature vala)
		$(meson_feature webp)
		$(meson_feature wmf)
		$(meson_feature X xcursor)
		$(meson_feature xpm)
		$(meson_use doc g-ir-doc)
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
		cd "${ED}"/usr/$(get_libdir)/gimp/2.99/plug-ins || exit 1
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
	meson_src_test
}

src_install() {
	meson_src_install

	if use python; then
		python_optimize
	fi

	# Workaround for bug #321111 to give GIMP the least
	# precedence on PDF documents by default
	mv "${ED}"/usr/share/applications/{,zzz-}gimp.desktop || die

	find "${D}" -name '*.la' -type f -delete || die

	# Prevent dead symlink gimp-console.1 from downstream man page compression (bug #433527)
	mv "${ED}"/usr/share/man/man1/gimp-console{-*,}.1 || die

	# Create symlinks for Gimp exec in /usr/bin
	dosym "${ESYSROOT}"/usr/bin/gimp-2.99 /usr/bin/gimp
	dosym "${ESYSROOT}"/usr/bin/gimp-console-2.99 /usr/bin/gimp-console
	dosym "${ESYSROOT}"/usr/bin/gimp-script-fu-interpreter-3.0 /usr/bin/gimp-script-fu-interpreter
	dosym "${ESYSROOT}"/usr/bin/gimp-test-clipboard-2.99 /usr/bin/gimp-test-clipboard
	dosym "${ESYSROOT}"/usr/bin/gimptool-2.99 /usr/bin/gimptool

	_rename_plugins || die
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
