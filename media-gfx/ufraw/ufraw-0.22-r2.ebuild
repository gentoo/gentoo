# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2-utils toolchain-funcs xdg-utils

DESCRIPTION="RAW Image format viewer and GIMP plugin"
HOMEPAGE="http://ufraw.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE="contrast fits gimp gnome gtk jpeg2k openmp timezone"

REQUIRED_USE="gimp? ( gtk )"

RDEPEND="
	dev-libs/glib:2=
	>=media-gfx/exiv2-0.11:0=
	media-libs/lcms:2=
	>=media-libs/lensfun-0.2.5:=
	media-libs/libpng:0=
	media-libs/tiff:0=
	virtual/jpeg:0=
	fits? ( sci-libs/cfitsio:0= )
	gimp? ( >=media-gfx/gimp-2 )
	gnome? ( >=gnome-base/gconf-2 )
	gtk? (
		>=media-gfx/gtkimageview-1.5
		>=x11-libs/gtk+-2.6:2
	)
	jpeg2k? ( media-libs/jasper:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.17-cfitsio-automagic.patch
	"${FILESDIR}"/${P}-jasper-automagic.patch
	"${FILESDIR}"/${P}-crashfix.patch
	"${FILESDIR}"/${P}-drop_superfluous_abs.patch
	"${FILESDIR}"/${P}-fix-unsigned-char.patch
	"${FILESDIR}"/${P}-jpeg9.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable contrast) \
		$(use_with fits cfitsio) \
		$(use_with gimp) \
		$(use_enable gnome mime) \
		$(use_with gtk) \
		$(use_enable jpeg2k jasper) \
		$(use_enable openmp) \
		$(use_enable timezone dst-correction)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${D}" schemasdir=/etc/gconf/schemas install
	einstalldocs
}

pkg_preinst() {
	if use gnome; then
		gnome2_gconf_savelist
	fi
}

pkg_postinst() {
	if use gnome; then
		xdg_mimeinfo_database_update
		xdg_desktop_database_update
		gnome2_gconf_install
	fi
}

pkg_postrm() {
	if use gnome; then
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
	fi
}
