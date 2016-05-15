# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils flag-o-matic toolchain-funcs gnome2-utils fdo-mime pax-utils eutils

DOC_PV="1.6.0"

DESCRIPTION="A virtual lighttable and darkroom for photographers"
HOMEPAGE="http://www.darktable.org/"
SRC_URI="https://github.com/darktable-org/${PN}/releases/download/release-${PV}/${P}.tar.xz
	doc? ( https://github.com/darktable-org/${PN}/releases/download/release-${DOC_PV}/${PN}-usermanual.pdf -> ${PN}-usermanual-${DOC_PV}.pdf )"

LICENSE="GPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
LANGS=" ca cs da de el es fr it ja nl pl pt_BR pt_PT ru sq sv uk"
# TODO add lua once dev-lang/lua-5.2 is unmasked
IUSE="colord cpu_flags_x86_sse3 doc flickr geo gphoto2 graphicsmagick jpeg2k kde libsecret
nls opencl openmp openexr pax_kernel +rawspeed +slideshow +squish web-services webp
${LANGS// / linguas_}"

# sse3 support is required to build darktable
REQUIRED_USE="cpu_flags_x86_sse3"

CDEPEND="
	dev-db/sqlite:3
	>=dev-libs/glib-2.28:2
	dev-libs/libxml2:2
	gnome-base/librsvg:2
	media-gfx/exiv2:0=[xmp]
	media-libs/lcms:2
	>=media-libs/lensfun-0.2.3
	media-libs/libpng:0=
	media-libs/tiff:0
	net-misc/curl
	virtual/jpeg:0
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/pango
	colord? ( x11-misc/colord:0= )
	flickr? ( media-libs/flickcurl )
	geo? ( net-libs/libsoup:2.4 )
	gphoto2? ( media-libs/libgphoto2:= )
	graphicsmagick? ( media-gfx/graphicsmagick )
	jpeg2k? ( media-libs/openjpeg:0 )
	libsecret? (
		>=app-crypt/libsecret-0.18
		dev-libs/json-glib
	)
	opencl? ( virtual/opencl )
	openexr? ( media-libs/openexr:0= )
	slideshow? (
		media-libs/libsdl
		virtual/glu
		virtual/opengl
	)
	web-services? ( dev-libs/json-glib )
	webp? ( media-libs/libwebp:0= )"
RDEPEND="${CDEPEND}
	x11-themes/gtk-engines:2
	kde? ( kde-apps/kwalletd:4 )"
DEPEND="${CDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	use cpu_flags_x86_sse3 && append-flags -msse3

	sed -e "s:\(/share/doc/\)darktable:\1${PF}:" \
		-e "s:\(\${SHARE_INSTALL}/doc/\)darktable:\1${PF}:" \
		-e "s:LICENSE::" \
		-i doc/CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use colord COLORD)
		$(cmake-utils_use_use flickr FLICKR)
		$(cmake-utils_use_use geo GEO)
		$(cmake-utils_use_use gphoto2 CAMERA_SUPPORT)
		$(cmake-utils_use_use graphicsmagick GRAPHICSMAGICK)
		$(cmake-utils_use_use jpeg2k OPENJPEG)
		$(cmake-utils_use_use kde KWALLET)
		$(cmake-utils_use_use libsecret LIBSECRET)
		$(cmake-utils_use_use libsecret GLIBJSON)
		$(cmake-utils_use_use nls NLS)
		$(cmake-utils_use_use opencl OPENCL)
		$(cmake-utils_use_use openexr OPENEXR)
		$(cmake-utils_use_use openmp OPENMP)
		$(cmake-utils_use !rawspeed DONT_USE_RAWSPEED)
		$(cmake-utils_use_use squish SQUISH)
		$(cmake-utils_use_build slideshow SLIDESHOW)
		$(cmake-utils_use_use web-services GLIBJSON)
		$(cmake-utils_use_use webp WEBP)
		-DUSE_LUA=OFF
		-DCUSTOM_CFLAGS=ON
		-DINSTALL_IOP_EXPERIMENTAL=ON
		-DINSTALL_IOP_LEGACY=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc "${DISTDIR}"/${PN}-usermanual-${DOC_PV}.pdf

	for lang in ${LANGS} ; do
		use linguas_${lang} || rm -r "${ED}"/usr/share/locale/${lang}
	done

	if use pax_kernel && use opencl ; then
		pax-mark Cm "${ED}"/usr/bin/${PN} || die
		eqawarn "USE=pax_kernel is set meaning that ${PN} will be run"
		eqawarn "under a PaX enabled kernel. To do so, the ${PN} binary"
		eqawarn "must be modified and this *may* lead to breakage! If"
		eqawarn "you suspect that ${PN} is broken by this modification,"
		eqawarn "please open a bug."
	fi
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
