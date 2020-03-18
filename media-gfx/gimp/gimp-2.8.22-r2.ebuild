# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit versionator virtualx autotools eutils gnome2 fdo-mime ltprune multilib python-single-r1

DESCRIPTION="GNU Image Manipulation Program"
HOMEPAGE="https://www.gimp.org/"
SRC_URI="mirror://gimp/v$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-3 LGPL-3"
SLOT="2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

LANGS="am ar ast az be bg br ca ca@valencia cs csb da de dz el en_CA en_GB eo es et eu fa fi fr ga gl gu he hi hr hu id is it ja ka kk km kn ko lt lv mk ml ms my nb nds ne nl nn oc pa pl pt pt_BR ro ru rw si sk sl sr sr@latin sv ta te th tr tt uk vi xh yi zh_CN zh_HK zh_TW"
IUSE="alsa aalib altivec aqua bzip2 curl dbus debug doc exif gnome postscript jpeg lcms cpu_flags_x86_mmx mng pdf png python smp cpu_flags_x86_sse svg tiff udev wmf xpm"

RDEPEND=">=dev-libs/glib-2.30.2:2
	>=dev-libs/atk-2.2.0
	>=x11-libs/gtk+-2.24.10:2
	>=x11-libs/gdk-pixbuf-2.24.1:2
	>=x11-libs/cairo-1.10.2
	>=x11-libs/pango-1.29.4
	xpm? ( x11-libs/libXpm )
	>=media-libs/freetype-2.1.7
	>=media-libs/fontconfig-2.2.0
	sys-libs/zlib
	dev-libs/libxml2
	dev-libs/libxslt
	x11-themes/hicolor-icon-theme
	>=media-libs/babl-0.1.10
	>=media-libs/gegl-0.2.0:0
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	aqua? ( x11-libs/gtk-mac-integration )
	curl? ( net-misc/curl )
	dbus? ( dev-libs/dbus-glib )
	gnome? ( gnome-base/gvfs )
	jpeg? ( virtual/jpeg:0 )
	exif? ( >=media-libs/libexif-0.6.15 )
	lcms? ( >=media-libs/lcms-2.2:2 )
	mng? ( media-libs/libmng )
	pdf? ( >=app-text/poppler-0.12.4[cairo] )
	png? ( >=media-libs/libpng-1.2.37:0 )
	python?	(
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/pygtk-2.10.4:2[${PYTHON_MULTI_USEDEP}]
		')
	)
	tiff? ( >=media-libs/tiff-3.5.7:0 )
	svg? ( >=gnome-base/librsvg-2.36.0:2 )
	wmf? ( >=media-libs/libwmf-0.2.8 )
	x11-libs/libXcursor
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	postscript? ( app-text/ghostscript-gpl )
	udev? ( dev-libs/libgudev:= )"
DEPEND="${RDEPEND}
	sys-apps/findutils
	virtual/pkgconfig
	>=dev-util/intltool-0.40.1
	>=sys-devel/gettext-0.19
	doc? ( >=dev-util/gtk-doc-1 )
	>=sys-devel/libtool-2.2
	>=sys-devel/automake-1.11
	dev-util/gtk-doc-am"  # due to our call to eautoreconf below (bug #386453)

DOCS="AUTHORS ChangeLog* HACKING NEWS README*"

S="${WORKDIR}"/${P}

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	G2CONF="--enable-default-binary \
		$(use_with !aqua x) \
		$(use_with aalib aa) \
		$(use_with alsa) \
		$(use_enable altivec) \
		$(use_with bzip2) \
		$(use_with curl libcurl) \
		$(use_with dbus) \
		$(use_with gnome gvfs) \
		--without-webkit \
		$(use_with jpeg libjpeg) \
		--without-libjasper \
		$(use_with exif libexif) \
		$(use_with lcms lcms lcms2) \
		$(use_with postscript gs) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_with mng libmng) \
		$(use_with pdf poppler) \
		$(use_with png libpng) \
		$(use_enable python) \
		$(use_enable smp mp) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_with svg librsvg) \
		$(use_with tiff libtiff) \
		$(use_with udev gudev) \
		$(use_with wmf) \
		--with-xmc \
		$(use_with xpm libxpm) \
		--without-xvfb-run"

	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-cve-2017-17784.patch  # bug 641954
	epatch "${FILESDIR}"/${P}-cve-2017-17785.patch  # bug 641954
	epatch "${FILESDIR}"/${P}-cve-2017-17786-1.patch  # bug 641954
	epatch "${FILESDIR}"/${P}-cve-2017-17786-2.patch  # bug 641954
	epatch "${FILESDIR}"/${P}-cve-2017-17787.patch  # bug 641954
	epatch "${FILESDIR}"/${P}-cve-2017-17788.patch  # bug 641954
	epatch "${FILESDIR}"/${P}-cve-2017-17789.patch  # bug 641954

	epatch "${FILESDIR}"/${PN}-2.8.14-blend-center.patch  # bug 558878
	epatch "${FILESDIR}"/${PN}-2.7.4-no-deprecation.patch  # bug 395695, comment 9 and 16
	epatch "${FILESDIR}"/${PN}-2.8.10-clang.patch # bug 449370 compile with clang

	sed -i -e 's/== "xquartz"/= "xquartz"/' configure.ac || die #494864
	eautoreconf  # If you remove this: remove dev-util/gtk-doc-am from DEPEND, too

	gnome2_src_prepare
}

_clean_up_locales() {
	[[ -z ${LINGUAS+set} ]] && return
	einfo "Cleaning up locales..."
	for lang in ${LANGS}; do
		has ${lang} ${LINGUAS} && {
			einfo "- keeping ${lang}"
			continue
		}
		rm -Rf "${ED}"/usr/share/locale/"${lang}" || die
	done
}

src_test() {
	Xemake check
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
