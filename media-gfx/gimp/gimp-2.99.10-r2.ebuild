# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{8..10} )
GNOME2_EAUTORECONF=yes
VALA_MIN_API_VERSION="0.44"
VALA_USE_DEPEND=vapigen

inherit gnome2 lua-single python-single-r1 toolchain-funcs vala virtualx

DESCRIPTION="GNU Image Manipulation Program"
HOMEPAGE="https://www.gimp.org/"
SRC_URI="mirror://gimp/v2.99/${P}.tar.bz2"
LICENSE="GPL-3+ LGPL-3+"
SLOT="0/3"

IUSE="aalib alsa aqua doc gnome heif javascript jpeg2k jpegxl lua mng openexr postscript python udev unwind vala vector-icons webp wmf xpm cpu_flags_ppc_altivec cpu_flags_x86_mmx cpu_flags_x86_sse"
REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
"

RESTRICT="!test? ( test )"

# media-libs/{babl,gegl} are required to be built with USE="introspection"
# to fix the compilation checking of /usr/share/gir-1.0/{Babl-0.1gir,Gegl-0.4.gir}
COMMON_DEPEND="
	>=app-text/poppler-0.90.1[cairo]
	>=app-text/poppler-data-0.4.9
	>=dev-libs/appstream-glib-0.7.16
	>=dev-libs/atk-2.34.1
	>=dev-libs/glib-2.68.0:2
	>=dev-libs/json-glib-1.4.4
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=gnome-base/librsvg-2.40.21:2
	>=media-gfx/mypaint-brushes-2.0.2:=
	>=media-libs/babl-0.1.90[introspection,lcms,vala?]
	>=media-libs/fontconfig-2.12.6
	>=media-libs/freetype-2.10.2
	>=media-libs/gegl-0.4.36:0.4[cairo,introspection,lcms,vala?]
	>=media-libs/gexiv2-0.12.2
	>=media-libs/harfbuzz-2.6.5:=
	>=media-libs/lcms-2.9:2
	>=media-libs/libmypaint-1.6.1:=
	>=media-libs/libpng-1.6.37:0=
	>=media-libs/tiff-4.1.0:0
	net-libs/glib-networking[ssl]
	sys-libs/zlib
	virtual/jpeg
	>=x11-libs/cairo-1.16.0
	>=x11-libs/gdk-pixbuf-2.40.0:2[introspection]
	>=x11-libs/gtk+-3.24.16:3[introspection]
	x11-libs/libXcursor
	>=x11-libs/pango-1.44.7
	aalib? ( media-libs/aalib )
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	aqua? ( >=x11-libs/gtk-mac-integration-2.0.0 )
	heif? ( >=media-libs/libheif-1.9.1:= )
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
	xpm? ( x11-libs/libXpm )
"

RDEPEND="
	${COMMON_DEPEND}
	x11-themes/hicolor-icon-theme
	gnome? ( gnome-base/gvfs )
"

DEPEND="
	${COMMON_DEPEND}
	>=dev-lang/perl-5.30.3
	dev-util/gdbus-codegen
	dev-util/gtk-update-icon-cache
	>=dev-util/intltool-0.51.0
	>=sys-devel/autoconf-2.54
	>=sys-devel/automake-1.11
	>=sys-devel/gettext-0.21
	>=sys-devel/libtool-2.4.6
	doc? ( dev-util/gi-docgen )
	vala? ( $(vala_depend) )
"

# TODO: there are probably more atoms in DEPEND which should be in BDEPEND now
BDEPEND="virtual/pkgconfig"

DOCS=( "AUTHORS" "devel-docs/CODING_STYLE.md" "devel-docs/HACKING.md" "NEWS" "README" "README.i18n" )

# Bugs 685210 (and duplicate 691070)
PATCHES=(
	"${FILESDIR}/${PN}-2.10_fix_test-appdata.patch"
)

pkg_setup() {
	use lua && lua-single_pkg_setup

	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	sed -i -e 's/mypaint-brushes-1.0/mypaint-brushes-2.0/' configure.ac || die #737794

	sed -i -e 's/== "xquartz"/= "xquartz"/' configure.ac || die #494864
	sed 's:-DGIMP_DISABLE_DEPRECATED:-DGIMP_protect_DISABLE_DEPRECATED:g' -i configure.ac || die #615144

	gnome2_src_prepare  # calls eautoreconf

	sed 's:-DGIMP_protect_DISABLE_DEPRECATED:-DGIMP_DISABLE_DEPRECATED:g' -i configure || die #615144
	grep -F -q GIMP_DISABLE_DEPRECATED configure || die #615144, self-test

	export CC_FOR_BUILD="$(tc-getBUILD_CC)"
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

	local myconf=(
		GEGL="${EPREFIX}"/usr/bin/gegl-0.4
		GDBUS_CODEGEN="${EPREFIX}"/usr/bin/gdbus-codegen

		--enable-default-binary

		--disable-check-update
		--enable-mp
		--with-appdata-test
		--with-bug-report-url=https://bugs.gentoo.org/
		--with-xmc
		--without-libbacktrace
		--without-webkit
		--without-xvfb-run
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable doc gi-docgen)
		$(use_enable vector-icons)
		$(use_with aalib aa)
		$(use_with alsa)
		$(use_with !aqua x)
		$(use_with heif libheif)
		$(use_with javascript)
		$(use_with jpeg2k jpeg2000)
		$(use_with jpegxl)
		$(use_with lua)
		$(use_with mng libmng)
		$(use_with openexr)
		$(use_with postscript gs)
		$(use_with python)
		$(use_with udev gudev)
		$(use_with unwind libunwind)
		$(use_with vala)
		$(use_with webp)
		$(use_with wmf)
		$(use_with xpm libxpm)
	)

	gnome2_src_configure "${myconf[@]}"
}

src_compile() {
	export XDG_DATA_DIRS="${EPREFIX}"/usr/share  # bug 587004
	gnome2_src_compile
}

# for https://bugs.gentoo.org/664938
_rename_plugins() {
	einfo 'Renaming plug-ins to not collide with pre-2.10.6 file layout (bug #664938)...'
	local prefix=gimp-org-
	(
		cd "${ED}"/usr/$(get_libdir)/gimp/2.99/plug-ins || exit 1
		for plugin_slash in $(ls -d1 */); do
		    plugin=${plugin_slash%/}
		    if [[ -f ${plugin}/${plugin} ]]; then
			# NOTE: Folder and file name need to match for Gimp to load that plug-in
			#       so "file-svg/file-svg" becomes "${prefix}file-svg/${prefix}file-svg"
			mv ${plugin}/{,${prefix}}${plugin} || exit 1
			mv {,${prefix}}${plugin} || exit 1
		    fi
		done
	)
}

src_test() {
	virtx emake check
}

src_install() {
	gnome2_src_install

	if use python; then
		python_optimize
	fi

	# Workaround for bug #321111 to give GIMP the least
	# precedence on PDF documents by default
	mv "${ED}"/usr/share/applications/{,zzz-}gimp.desktop || die

	find "${D}" -name '*.la' -type f -delete || die

	# Prevent dead symlink gimp-console.1 from downstream man page compression (bug #433527)
	mv "${ED}"/usr/share/man/man1/gimp-console{-*,}.1 || die

	_rename_plugins || die
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
