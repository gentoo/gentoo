# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
GNOME2_EAUTORECONF=yes

inherit autotools gnome2 python-single-r1 virtualx

DESCRIPTION="GNU Image Manipulation Program"
HOMEPAGE="https://www.gimp.org/"
SRC_URI="mirror://gimp/v2.10/${P}.tar.bz2"
LICENSE="GPL-3 LGPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"

IUSE="aalib alsa altivec aqua debug doc gnome heif jpeg2k mng openexr postscript python udev unwind vector-icons webp wmf xpm cpu_flags_x86_mmx cpu_flags_x86_sse"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	app-arch/bzip2
	>=app-arch/xz-utils-5.0.0
	>=app-text/poppler-0.50[cairo]
	>=app-text/poppler-data-0.4.7
	>=dev-libs/atk-2.2.0
	>=dev-libs/glib-2.54.2:2
	dev-libs/libxml2
	dev-libs/libxslt
	>=gnome-base/librsvg-2.40.6:2
	>=media-gfx/mypaint-brushes-1.3.0
	>=media-libs/babl-0.1.62
	>=media-libs/fontconfig-2.12.4
	>=media-libs/freetype-2.1.7
	>=media-libs/gegl-0.4.14:0.4[cairo]
	>=media-libs/gexiv2-0.10.6
	>=media-libs/harfbuzz-0.9.19
	>=media-libs/lcms-2.8:2
	>=media-libs/libmypaint-1.3.0:=
	>=media-libs/libpng-1.6.25:0=
	>=media-libs/tiff-3.5.7:0
	net-libs/glib-networking[ssl]
	sys-libs/zlib
	virtual/jpeg:0
	>=x11-libs/cairo-1.12.2
	>=x11-libs/gdk-pixbuf-2.30.8:2
	>=x11-libs/gtk+-2.24.32:2
	x11-libs/libXcursor
	>=x11-libs/pango-1.29.4
	aalib? ( media-libs/aalib )
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	aqua? ( >=x11-libs/gtk-mac-integration-2.0.0 )
	heif? ( >=media-libs/libheif-1.1.0:= )
	jpeg2k? ( >=media-libs/openjpeg-2.1.0:2= )
	mng? ( media-libs/libmng:= )
	openexr? ( >=media-libs/openexr-1.6.1:= )
	postscript? ( app-text/ghostscript-gpl )
	python?	(
		${PYTHON_DEPS}
		>=dev-python/pycairo-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/pygtk-2.10.4:2[${PYTHON_USEDEP}]
	)
	udev? ( dev-libs/libgudev:= )
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
	>=dev-lang/perl-5.10.0
	dev-libs/appstream-glib
	dev-util/gtk-update-icon-cache
	>=dev-util/intltool-0.40.1
	sys-apps/findutils
	>=sys-devel/automake-1.11
	>=sys-devel/gettext-0.19
	>=sys-devel/libtool-2.2
	virtual/pkgconfig
"

DOCS=( "AUTHORS" "ChangeLog" "HACKING" "NEWS" "README" "README.i18n" )

# Bugs 685210 (and duplicate 691070)
PATCHES=(
	"${FILESDIR}/${PN}-2.10_fix_test-appdata.patch"
)

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	# Disable system CFLAGS suppressing on SSE{2,4.1} support tests by addition of {SSE2,SSE4_1}_EXTRA_CFLAGS: bug #702554
	sed -i -e 's:\$intrinsics_save_CFLAGS \$SSE2_EXTRA_CFLAGS:\$SSE2_EXTRA_CFLAGS \$intrinsics_save_CFLAGS:' \
		-e 's:\$intrinsics_save_CFLAGS \$SSE4_1_EXTRA_CFLAGS:\$SSE4_1_EXTRA_CFLAGS \$intrinsics_save_CFLAGS:' configure.ac || die

	sed -i -e 's/== "xquartz"/= "xquartz"/' configure.ac || die #494864
	sed 's:-DGIMP_DISABLE_DEPRECATED:-DGIMP_protect_DISABLE_DEPRECATED:g' -i configure.ac || die #615144

	gnome2_src_prepare  # calls eautoreconf

	sed 's:-DGIMP_protect_DISABLE_DEPRECATED:-DGIMP_DISABLE_DEPRECATED:g' -i configure || die #615144
	fgrep -q GIMP_DISABLE_DEPRECATED configure || die #615144, self-test
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

	local myconf=(
		GEGL="${EPREFIX}"/usr/bin/gegl-0.4
		GDBUS_CODEGEN="${EPREFIX}"/bin/false

		--enable-default-binary

		--enable-mp
		--with-appdata-test
		--with-bug-report-url=https://bugs.gentoo.org/
		--with-xmc
		--without-libbacktrace
		--without-webkit
		--without-xvfb-run
		$(use_enable altivec)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable python)
		$(use_enable vector-icons)
		$(use_with aalib aa)
		$(use_with alsa)
		$(use_with !aqua x)
		$(use_with heif libheif)
		$(use_with jpeg2k jpeg2000)
		$(use_with mng libmng)
		$(use_with openexr)
		$(use_with postscript gs)
		$(use_with udev gudev)
		$(use_with unwind libunwind)
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
	local prepend=gimp-org-
	(
		cd "${ED%/}"/usr/$(get_libdir)/gimp/2.0/plug-ins || exit 1
		for plugin_slash in $(ls -d1 */); do
		    plugin=${plugin_slash%/}
		    if [[ -f ${plugin}/${plugin} ]]; then
			# NOTE: Folder and file name need to match for Gimp to load that plug-in
			#       so "file-svg/file-svg" becomes "${prepend}file-svg/${prepend}file-svg"
			mv ${plugin}/{,${prepend}}${plugin} || exit 1
			mv {,${prepend}}${plugin} || exit 1
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
	mv "${ED%/}"/usr/share/applications/{,zzz-}gimp.desktop || die

	find "${D}" -name '*.la' -type f -delete || die

	# Prevent dead symlink gimp-console.1 from downstream man page compression (bug #433527)
	local gimp_app_version=$(get_version_component_range 1-2)
	mv "${ED%/}"/usr/share/man/man1/gimp-console{-${gimp_app_version},}.1 || die

	# Remove gimp devel-docs html files if user doesn't need it
	if ! use doc; then
		rm -r "${ED%/}"/usr/share/gtk-doc || die
	fi

	_rename_plugins || die
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
