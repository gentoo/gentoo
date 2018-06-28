# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit gnome2-utils python-single-r1 xdg-utils

DESCRIPTION="postscript font editor and converter"
HOMEPAGE="http://fontforge.github.io/"
SRC_URI="https://github.com/fontforge/fontforge/releases/download/${PV}/fontforge-dist-${PV}.tar.xz"

LICENSE="BSD GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="cairo truetype-debugger gif gtk jpeg png +python readline test tiff svg unicode X"

RESTRICT="!test? ( test )"

REQUIRED_USE="
	cairo? ( png )
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( png python )
"

RDEPEND="
	dev-libs/libltdl:0
	dev-libs/libxml2:2=
	>=media-libs/freetype-2.3.7:2=
	cairo? (
		>=x11-libs/cairo-1.6:0=
		x11-libs/pango:0=
	)
	gif? ( media-libs/giflib:0= )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0= )
	truetype-debugger? ( >=media-libs/freetype-2.3.8:2[fontforge,-bindist(-)] )
	gtk? ( x11-libs/gtk+:2= )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	unicode? ( media-libs/libuninameslist:0= )
	X? (
		x11-libs/libX11:0=
		x11-libs/libXi:0=
		>=x11-libs/pango-1.10:0=[X]
	)
	!media-gfx/pfaedit
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	X? ( x11-base/xorg-proto )
"

# Needs keywording on many arches.
#	zeromq? (
#		>=net-libs/czmq-2.2.0:0=
#		>=net-libs/zeromq-4.0.4:0=
#	)

S="${WORKDIR}/fontforge-2.0.${PV}"

PATCHES=(
	"${FILESDIR}"/20170731-startnoui-FindOrMakeEncoding.patch
	"${FILESDIR}"/20170731-tilepath.patch
	"${FILESDIR}"/20170731-gethex-unaligned.patch
	"${FILESDIR}"/20170731-PyMem_Free.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable truetype-debugger freetype-debugger "${EPREFIX}/usr/include/freetype2/internal4fontforge")
		$(use_enable gtk gtk2-use)
		$(use_enable python python-extension)
		$(use_enable python python-scripting)
		--enable-tile-path
		--enable-gb12345
		$(use_with cairo)
		$(use_with gif giflib)
		$(use_with jpeg libjpeg)
		$(use_with png libpng)
		$(use_with readline libreadline)
		--without-libspiro
		$(use_with tiff libtiff)
		$(use_with unicode libuninameslist)
		#$(use_with zeromq libzmq)
		--without-libzmq
		$(use_with X x)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	# Build system deps are broken
	emake -C plugins
	emake
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
