# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic toolchain-funcs gnome2-utils fdo-mime pax-utils eutils

DOC_PV="2.2.0"
MY_PV="${PV/_/}"
MY_P="${P/_/.}"

DESCRIPTION="A virtual lighttable and darkroom for photographers"
HOMEPAGE="http://www.darktable.org/"
SRC_URI="https://github.com/darktable-org/${PN}/releases/download/release-${MY_PV}/${MY_P}.tar.xz
	doc? ( https://github.com/darktable-org/${PN}/releases/download/release-${DOC_PV}/${PN}-usermanual.pdf -> ${PN}-usermanual-${DOC_PV}.pdf )"

LICENSE="GPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LANGS=" ca cs da de es fr he hu it ja nl pl ru sk sl sv uk"
# TODO add lua once dev-lang/lua-5.2 is unmasked
IUSE="colord cups cpu_flags_x86_sse3 doc flickr geo gphoto2 graphicsmagick jpeg2k kwallet libsecret
nls opencl openmp openexr pax_kernel webp
${LANGS// / l10n_}"

# sse3 support is required to build darktable
REQUIRED_USE="cpu_flags_x86_sse3"

CDEPEND="
	dev-db/sqlite:3
	dev-libs/json-glib
	dev-libs/libxml2:2
	dev-libs/pugixml:0=
	gnome-base/librsvg:2
	>=media-gfx/exiv2-0.25-r2:0=[xmp]
	media-libs/lcms:2
	>=media-libs/lensfun-0.2.3:0=
	media-libs/libpng:0=
	media-libs/tiff:0
	net-libs/libsoup:2.4
	net-misc/curl
	virtual/jpeg:0
	virtual/glu
	virtual/opengl
	x11-libs/cairo
	>=x11-libs/gtk+-3.14:3
	x11-libs/pango
	colord? ( x11-libs/colord-gtk:0= )
	cups? ( net-print/cups )
	flickr? ( media-libs/flickcurl )
	geo? ( >=sci-geosciences/osm-gps-map-1.1.0 )
	gphoto2? ( media-libs/libgphoto2:= )
	graphicsmagick? ( media-gfx/graphicsmagick )
	jpeg2k? ( media-libs/openjpeg:0 )
	libsecret? ( >=app-crypt/libsecret-0.18 )
	opencl? ( virtual/opencl )
	openexr? ( media-libs/openexr:0= )
	webp? ( media-libs/libwebp:0= )"
RDEPEND="${CDEPEND}
	kwallet? ( kde-apps/kwalletd:4 )"
DEPEND="${CDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${P/_/~}"

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	use cpu_flags_x86_sse3 && append-flags -msse3

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_PRINT=$(usex cups)
		-DCMAKE_INSTALL_DOCDIR="/usr/share/doc/${PF}"
		-DCUSTOM_CFLAGS=ON
		-DUSE_CAMERA_SUPPORT=$(usex gphoto2)
		-DUSE_COLORD=$(usex colord)
		-DUSE_FLICKR=$(usex flickr)
		-DUSE_GRAPHICSMAGICK=$(usex graphicsmagick)
		-DUSE_KWALLET=$(usex kwallet)
		-DUSE_LIBSECRET=$(usex libsecret)
		-DUSE_LUA=OFF
		-DUSE_MAP=$(usex geo)
		-DUSE_NLS=$(usex nls)
		-DUSE_OPENCL=$(usex opencl)
		-DUSE_OPENEXR=$(usex openexr)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_WEBP=$(usex webp)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc "${DISTDIR}"/${PN}-usermanual-${DOC_PV}.pdf

	for lang in ${LANGS} ; do
		use l10n_${lang} || rm -r "${ED}"/usr/share/locale/${lang/-/_}
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

	elog "when updating from the currently stable 1.6 series,"
	elog "please bear in mind that your edits will be preserved during this process,"
	elog "but it will not be possible to downgrade from 2.0 to 1.6 any more."
	echo
	ewarn "It will not be possible to downgrade!"
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}
