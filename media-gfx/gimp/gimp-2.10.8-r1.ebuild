# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
GNOME2_EAUTORECONF=yes

MY_PV="${PV/_rc/-RC}"
MY_P="${PN}-${MY_PV}"

inherit versionator virtualx autotools gnome2 multilib python-single-r1 ltprune

DESCRIPTION="GNU Image Manipulation Program"
HOMEPAGE="https://www.gimp.org/"
SRC_URI="mirror://gimp/v$(get_version_component_range 1-2)/${MY_P}.tar.bz2"
LICENSE="GPL-3 LGPL-3"
SLOT="2"
KEYWORDS="amd64 arm64 x86"

LANGS="am ar ast az be bg br ca ca@valencia cs csb da de dz el en_CA en_GB eo es et eu fa fi fr ga gl gu he hi hr hu id is it ja ka kk km kn ko lt lv mk ml ms my nb nds ne nl nn oc pa pl pt pt_BR ro ru rw si sk sl sr sr@latin sv ta te th tr tt uk vi xh yi zh_CN zh_HK zh_TW"
IUSE="alsa aalib altivec aqua debug doc openexr gnome heif postscript jpeg2k cpu_flags_x86_mmx mng python cpu_flags_x86_sse udev unwind vector-icons webp wmf xpm"

RDEPEND=">=dev-libs/glib-2.56.0:2
	>=dev-libs/atk-2.2.0
	>=x11-libs/gtk+-2.24.10:2
	>=x11-libs/gdk-pixbuf-2.31:2
	>=x11-libs/cairo-1.12.2
	>=x11-libs/pango-1.29.4
	xpm? ( x11-libs/libXpm )
	>=media-libs/freetype-2.1.7
	>=media-libs/harfbuzz-0.9.19
	>=media-libs/gexiv2-0.10.6
	>=media-libs/libmypaint-1.3.0
	>=media-gfx/mypaint-brushes-1.3.0
	>=media-libs/fontconfig-2.12.4
	sys-libs/zlib
	dev-libs/libxml2
	dev-libs/libxslt
	x11-themes/hicolor-icon-theme
	>=media-libs/babl-0.1.58
	>=media-libs/gegl-0.4.12:0.4[cairo]
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	aqua? ( x11-libs/gtk-mac-integration )
	gnome? ( gnome-base/gvfs )
	virtual/jpeg:0
	jpeg2k? ( >=media-libs/openjpeg-2.1.0:2= )
	>=media-libs/lcms-2.8:2
	mng? ( media-libs/libmng )
	openexr? ( >=media-libs/openexr-1.6.1:= )
	>=app-text/poppler-0.44[cairo]
	>=app-text/poppler-data-0.4.7
	>=media-libs/libpng-1.6.25:0=
	python?	(
		${PYTHON_DEPS}
		>=dev-python/pygtk-2.10.4:2[${PYTHON_USEDEP}]
		>=dev-python/pycairo-1.0.2[${PYTHON_USEDEP}]
	)
	>=media-libs/tiff-3.5.7:0
	>=gnome-base/librsvg-2.40.6:2
	webp? ( >=media-libs/libwebp-0.6.0 )
	wmf? ( >=media-libs/libwmf-0.2.8 )
	net-libs/glib-networking[ssl]
	x11-libs/libXcursor
	sys-libs/zlib
	app-arch/bzip2
	>=app-arch/xz-utils-5.0.0
	postscript? ( app-text/ghostscript-gpl )
	udev? ( dev-libs/libgudev:= )
	unwind? ( sys-libs/libunwind:= )
	heif? ( >=media-libs/libheif-1.1.0:= )"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.10.0
	dev-libs/appstream-glib
	dev-util/gtk-update-icon-cache
	sys-apps/findutils
	virtual/pkgconfig
	>=dev-util/intltool-0.40.1
	>=sys-devel/gettext-0.19
	doc? ( >=dev-util/gtk-doc-1 )
	>=sys-devel/libtool-2.2
	>=sys-devel/automake-1.11
	dev-util/gtk-doc-am"

DOCS="AUTHORS ChangeLog* HACKING NEWS README*"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
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
		--disable-silent-rules

		$(use_with !aqua x)
		$(use_with aalib aa)
		$(use_with alsa)
		$(use_enable altivec)
		--with-appdata-test
		--without-libbacktrace
		--with-bug-report-url=https://bugs.gentoo.org/
		--without-webkit
		$(use_with jpeg2k jpeg2000)
		$(use_with postscript gs)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_with mng libmng)
		$(use_with openexr)
		$(use_with webp)
		$(use_with heif libheif)
		$(use_enable python)
		--enable-mp
		$(use_enable cpu_flags_x86_sse sse)
		$(use_with udev gudev)
		$(use_with unwind libunwind)
		$(use_with wmf)
		--with-xmc
		$(use_with xpm libxpm)
		$(use_enable vector-icons)
		--without-xvfb-run
	)

	gnome2_src_configure "${myconf[@]}"
}

src_compile() {
	export XDG_DATA_DIRS="${EPREFIX}"/usr/share  # bug 587004
	gnome2_src_compile
}

_clean_up_locales() {
	[[ -z ${LINGUAS+set} ]] && return
	einfo "Cleaning up locales..."
	for lang in ${LANGS}; do
		has ${lang} ${LINGUAS} && {
			einfo "- keeping ${lang}"
			continue
		}
		rm -Rf "${ED%/}"/usr/share/locale/"${lang}"
	done
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

	prune_libtool_files --all

	# Prevent dead symlink gimp-console.1 from downstream man page compression (bug #433527)
	local gimp_app_version=$(get_version_component_range 1-2)
	mv "${ED%/}"/usr/share/man/man1/gimp-console{-${gimp_app_version},}.1 || die

	_rename_plugins || die
	_clean_up_locales
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
