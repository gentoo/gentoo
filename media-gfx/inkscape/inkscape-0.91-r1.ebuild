# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit autotools eutils flag-o-matic gnome2-utils fdo-mime toolchain-funcs python-single-r1

MY_P=${P/_/}

DESCRIPTION="A SVG based generic vector-drawing program"
HOMEPAGE="http://www.inkscape.org/"
SRC_URI="https://inkscape.global.ssl.fastly.net/media/resources/file/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="cdr dia dbus exif gnome imagemagick openmp postscript inkjar jpeg lcms nls spell static-libs visio wpg"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

WPG_DEPS="
	|| (
		( app-text/libwpg:0.3 dev-libs/librevenge )
		( app-text/libwpd:0.9 app-text/libwpg:0.2 )
	)
"
COMMON_DEPEND="
	${PYTHON_DEPS}
	>=app-text/poppler-0.26.0:=[cairo]
	>=dev-cpp/glibmm-2.28
	>=dev-cpp/gtkmm-2.18.0:2.4
	>=dev-cpp/cairomm-1.9.8
	>=dev-cpp/glibmm-2.32
	>=dev-libs/boehm-gc-6.4
	>=dev-libs/glib-2.28
	>=dev-libs/libsigc++-2.0.12
	>=dev-libs/libxml2-2.6.20
	>=dev-libs/libxslt-1.0.15
	dev-libs/popt
	dev-python/lxml[${PYTHON_USEDEP}]
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libpng:0
	sci-libs/gsl
	x11-libs/libX11
	>=x11-libs/gtk+-2.10.7:2
	>=x11-libs/pango-1.24
	cdr? (
		media-libs/libcdr
		${WPG_DEPS}
	)
	dbus? ( dev-libs/dbus-glib )
	exif? ( media-libs/libexif )
	gnome? ( >=gnome-base/gnome-vfs-2.0 )
	imagemagick? ( media-gfx/imagemagick:=[cxx] )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	spell? (
		app-text/aspell
		app-text/gtkspell:2
	)
	visio? (
		media-libs/libvisio
		${WPG_DEPS}
	)
	wpg? ( ${WPG_DEPS} )
"

# These only use executables provided by these packages
# See share/extensions for more details. inkscape can tell you to
# install these so we could of course just not depend on those and rely
# on that.
RDEPEND="${COMMON_DEPEND}
	dev-python/numpy[${PYTHON_USEDEP}]
	media-gfx/uniconvertor
	dia? ( app-office/dia )
	postscript? ( app-text/ghostscript-gpl )
"

DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.36
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_P}

RESTRICT="test"

pkg_pretend() {
	if use openmp; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-0.91_pre3-automagic.patch \
		"${FILESDIR}"/${PN}-0.91_pre3-cppflags.patch \
		"${FILESDIR}"/${PN}-0.91_pre3-desktop.patch \
		"${FILESDIR}"/${PN}-0.91_pre3-exif.patch \
		"${FILESDIR}"/${PN}-0.91_pre3-sk-man.patch \
		"${FILESDIR}"/${PN}-0.48.4-epython.patch

	sed -i "s#@EPYTHON@#${EPYTHON}#" src/extension/implementation/script.cpp || die

	eautoreconf

	# bug 421111
	python_fix_shebang share/extensions
}

src_configure() {
	# aliasing unsafe wrt #310393
	append-flags -fno-strict-aliasing
	# enable c++11 as needed for sigc++-2.6, #566318
	# remove it when upstream solves the issue
	# https://bugs.launchpad.net/inkscape/+bug/1488079
	append-cxxflags -std=c++11

	econf \
		$(use_enable static-libs static) \
		$(use_enable nls) \
		$(use_enable openmp) \
		$(use_enable exif) \
		$(use_enable jpeg) \
		$(use_enable lcms) \
		--enable-poppler-cairo \
		$(use_enable wpg) \
		$(use_enable visio) \
		$(use_enable cdr) \
		$(use_enable dbus dbusapi) \
		$(use_enable imagemagick magick) \
		$(use_with gnome gnome-vfs) \
		$(use_with inkjar) \
		$(use_with spell gtkspell) \
		$(use_with spell aspell)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	prune_libtool_files
	python_optimize "${ED}"/usr/share/${PN}/extensions
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}
