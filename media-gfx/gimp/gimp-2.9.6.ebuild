# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit versionator virtualx autotools eutils gnome2 multilib python-single-r1

DESCRIPTION="GNU Image Manipulation Program"
HOMEPAGE="https://www.gimp.org/"
SRC_URI="mirror://gimp/v$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-3 LGPL-3"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc64 ~x86"

LANGS="am ar ast az be bg br ca ca@valencia cs csb da de dz el en_CA en_GB eo es et eu fa fi fr ga gl gu he hi hr hu id is it ja ka kk km kn ko lt lv mk ml ms my nb nds ne nl nn oc pa pl pt pt_BR ro ru rw si sk sl sr sr@latin sv ta te th tr tt uk vi xh yi zh_CN zh_HK zh_TW"
IUSE="alsa aalib altivec aqua debug doc openexr gnome postscript jpeg2k cpu_flags_x86_mmx mng pdf python smp cpu_flags_x86_sse udev vector-icons webp wmf xpm"

for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

RDEPEND=">=dev-libs/glib-2.40.0:2
	>=dev-libs/atk-2.2.0
	>=x11-libs/gtk+-2.24.10:2
	dev-util/gtk-update-icon-cache
	>=x11-libs/gdk-pixbuf-2.31:2
	>=x11-libs/cairo-1.12.2
	>=x11-libs/pango-1.29.4
	xpm? ( x11-libs/libXpm )
	>=media-libs/freetype-2.1.7
	>=media-libs/harfbuzz-0.9.19
	>=media-libs/gexiv2-0.10.6
	>=media-libs/libmypaint-1.3.0[gegl]
	>=media-libs/fontconfig-2.2.0
	sys-libs/zlib
	dev-libs/libxml2
	dev-libs/libxslt
	x11-themes/hicolor-icon-theme
	>=media-libs/babl-0.1.30
	>=media-libs/gegl-0.3.20:0.3[cairo]
	>=dev-libs/glib-2.43
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	aqua? ( x11-libs/gtk-mac-integration )
	gnome? ( gnome-base/gvfs )
	virtual/jpeg:0
	jpeg2k? ( media-libs/jasper:= )
	>=media-libs/lcms-2.7:2
	mng? ( media-libs/libmng )
	openexr? ( >=media-libs/openexr-1.6.1 )
	pdf? ( >=app-text/poppler-0.44[cairo] >=app-text/poppler-data-0.4.7 )
	>=media-libs/libpng-1.6.25:0
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
	udev? ( virtual/libgudev:= )"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	sys-apps/findutils
	virtual/pkgconfig
	>=dev-util/intltool-0.40.1
	>=sys-devel/gettext-0.19
	doc? ( >=dev-util/gtk-doc-1 )
	>=sys-devel/libtool-2.2
	>=sys-devel/automake-1.11
	dev-util/gtk-doc-am"  # due to our call to eautoreconf below (bug #386453)

DOCS="AUTHORS ChangeLog* HACKING NEWS README*"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	eapply "${FILESDIR}"/${P}-underlinking.patch  # from 629304
	eapply_user

	sed -i -e 's/== "xquartz"/= "xquartz"/' configure.ac || die #494864
	sed 's:-DGIMP_DISABLE_DEPRECATED:-DGIMP_protect_DISABLE_DEPRECATED:g' -i configure.ac || die #615144
	eautoreconf  # If you remove this: remove dev-util/gtk-doc-am from DEPEND, too

	gnome2_src_prepare

	sed 's:-DGIMP_protect_DISABLE_DEPRECATED:-DGIMP_DISABLE_DEPRECATED:g' -i configure || die #615144
	fgrep -q GIMP_DISABLE_DEPRECATED configure || die #615144, self-test
}

src_configure() {
	local myconf=(
		GEGL=${EPREFIX}/usr/bin/gegl-0.3
		GDBUS_CODEGEN=${EPREFIX}/bin/false

		--enable-default-binary
		--disable-silent-rules

		$(use_with !aqua x)
		$(use_with aalib aa)
		$(use_with alsa)
		$(use_enable altivec)
		--with-appdata-test
		--without-webkit
		$(use_with jpeg2k libjasper)
		$(use_with postscript gs)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_with mng libmng)
		$(use_with openexr)
		$(use_with webp)
		$(use_with pdf poppler)
		$(use_enable python)
		$(use_enable smp mp)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_with udev gudev)
		$(use_with wmf)
		--with-xmc
		$(use_with xpm libxpm)
		$(use_enable vector-icons)
		--without-xvfb-run
	)

	gnome2_src_configure "${myconf[@]}"
}

src_compile() {
	# Bugs #569738 and #591214
	local nv
	for nv in /dev/nvidia-uvm /dev/nvidiactl /dev/nvidia{0..9} ; do
		# We do not check for existence as they may show up later
		# https://bugs.gentoo.org/show_bug.cgi?id=569738#c21
		addwrite "${nv}"
	done
	addwrite /dev/dri/  # bug #574038
	addwrite /dev/ati/  # bug 589198
	addwrite /proc/mtrr  # bug 589198

	export XDG_DATA_DIRS=${EPREFIX}/usr/share  # bug 587004
	gnome2_src_compile
}

_clean_up_locales() {
	einfo "Cleaning up locales..."
	for lang in ${LANGS}; do
		use "linguas_${lang}" && {
			einfo "- keeping ${lang}"
			continue
		}
		rm -Rf "${ED}"/usr/share/locale/"${lang}" || die
	done
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

	prune_libtool_files --all

	# Prevent dead symlink gimp-console.1 from downstream man page compression (bug #433527)
	local gimp_app_version=$(get_version_component_range 1-2)
	mv "${ED}"/usr/share/man/man1/gimp-console{-${gimp_app_version},}.1 || die

	_clean_up_locales
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
