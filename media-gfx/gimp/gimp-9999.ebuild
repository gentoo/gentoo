# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gimp/gimp-9999.ebuild,v 1.56 2015/05/25 23:48:45 tetromino Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2 fdo-mime multilib python-single-r1 git-r3

EGIT_REPO_URI="git://git.gnome.org/gimp"

DESCRIPTION="GNU Image Manipulation Program"
HOMEPAGE="http://www.gimp.org/"
SRC_URI=""

LICENSE="GPL-3 LGPL-3"
SLOT="2"
KEYWORDS=""

LANGS="am ar ast az be bg br ca ca@valencia cs csb da de dz el en_CA en_GB eo es et eu fa fi fr ga gl gu he hi hr hu id is it ja ka kk km kn ko lt lv mk ml ms my nb nds ne nl nn oc pa pl pt pt_BR ro ru rw si sk sl sr sr@latin sv ta te th tr tt uk vi xh yi zh_CN zh_HK zh_TW"
IUSE="alsa aalib altivec aqua bzip2 curl dbus debug doc exif gnome openexr postscript jpeg jpeg2k lcms cpu_flags_x86_mmx mng pdf png python smp cpu_flags_x86_sse svg tiff udev webkit wmf xpm"

for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

RDEPEND=">=dev-libs/glib-2.40.0:2
	>=dev-libs/atk-2.2.0
	>=x11-libs/gtk+-2.24.10:2
	>=x11-libs/gdk-pixbuf-2.24.1:2
	>=x11-libs/cairo-1.12.2
	>=x11-libs/pango-1.29.4
	xpm? ( x11-libs/libXpm )
	>=media-libs/freetype-2.1.7
	>=media-libs/fontconfig-2.2.0
	>=media-libs/freetype-2.1.7:2
	>=media-libs/harfbuzz-0.9.19
	sys-libs/zlib
	dev-libs/libxml2
	dev-libs/libxslt
	x11-themes/hicolor-icon-theme
	>=media-libs/babl-0.1.11
	media-libs/gegl:0.3
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	aqua? ( x11-libs/gtk-mac-integration )
	curl? ( net-misc/curl )
	dbus? ( dev-libs/dbus-glib )
	gnome? ( gnome-base/gvfs )
	webkit? ( >=net-libs/webkit-gtk-1.6.1:2 )
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/jasper )
	>=media-libs/gexiv2-0.6.1
	lcms? ( >=media-libs/lcms-2.2:2 )
	mng? ( media-libs/libmng )
	pdf? ( >=app-text/poppler-0.12.4[cairo] )
	png? ( >=media-libs/libpng-1.2.37:0 )
	python?	(
		${PYTHON_DEPS}
		>=dev-python/pygtk-2.10.4:2[${PYTHON_USEDEP}]
	)
	tiff? ( >=media-libs/tiff-3.5.7:0 )
	svg? ( >=gnome-base/librsvg-2.36.0:2 )
	wmf? ( >=media-libs/libwmf-0.2.8 )
	x11-libs/libXcursor
	sys-libs/zlib
	>=app-arch/xz-utils-5.0.0
	openexr? ( >=media-libs/openexr-1.6.1 )
	>=app-text/poppler-data-0.4.7
	bzip2? ( app-arch/bzip2 )
	postscript? ( app-text/ghostscript-gpl )
	udev? ( virtual/libgudev:= )"
DEPEND="${RDEPEND}
	sys-apps/findutils
	virtual/pkgconfig
	>=dev-util/intltool-0.40.1
	>=sys-devel/gettext-0.19
	doc? ( >=dev-util/gtk-doc-1 )
	>=sys-devel/libtool-2.2
	>=sys-devel/autoconf-2.54
	>=sys-devel/automake-1.11
	dev-util/gtk-doc-am"  # due to our call to eautoreconf below (bug #386453)

DOCS="AUTHORS ChangeLog* HACKING NEWS README*"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	G2CONF="--enable-default-binary \
		--disable-silent-rules \
		$(use_with !aqua x) \
		$(use_with aalib aa) \
		$(use_with alsa) \
		$(use_enable altivec) \
		$(use_with openexr) \
		$(use_with webkit) \
		$(use_with jpeg2k libjasper) \
		$(use_with postscript gs) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_with mng libmng) \
		$(use_with pdf poppler) \
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
	sed -i -e 's/== "xquartz"/= "xquartz"/' configure.ac || die #494864

	echo '#!/bin/sh' > py-compile
	chmod a+x py-compile || die
	sed -i -e 's:\$srcdir/configure:#:g' autogen.sh
	local myconf
	if ! use doc; then
	    myconf="${myconf} --disable-gtk-doc"
	fi
	./autogen.sh ${myconf} || die

	# Fix "libtoolize --force" of autogen.sh (bug #476626)
	rm install-sh ltmain.sh || die
	_elibtoolize --copy --install || die

	gnome2_src_prepare
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

src_install() {
	gnome2_src_install

	if use python; then
		python_optimize
	fi

	# Workaround for bug #321111 to give GIMP the least
	# precedence on PDF documents by default
	mv "${ED}"/usr/share/applications/{,zzz-}gimp.desktop || die

	prune_libtool_files --all

	_clean_up_locales
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
