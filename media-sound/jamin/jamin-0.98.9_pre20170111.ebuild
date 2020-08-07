# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="Audio mastering interface for JACK Audio Connection Kit (JACK)"
HOMEPAGE="http://jamin.sourceforge.net/en/about.html https://salsa.debian.org/multimedia-team/jamin"
SRC_URI="http://deb.debian.org/debian/pool/main/j/${PN}/${PN}_${PV/_pre/~git}~199091~repack1.orig.tar.bz2
http://deb.debian.org/debian/pool/main/j/${PN}/${PN}_${PV/_pre/~git}~199091~repack1-1.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="osc"

RDEPEND="
	dev-libs/atk
	dev-libs/glib
	dev-libs/libxml2
	media-libs/libsndfile
	>=media-plugins/swh-plugins-0.4.6
	sci-libs/fftw:3.0=
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango
	virtual/jack
	osc? ( >=media-libs/liblo-0.26 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${WORKDIR}"/debian/patches/1003_add_dynamic_linking.patch
	"${WORKDIR}"/debian/patches/fix_typos.patch
	"${WORKDIR}"/debian/patches/NEWS.patch
	"${FILESDIR}"/${P}-gcc10.patch # thanks Fedora
	"${FILESDIR}"/${P}-desktop.patch
)

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	sed -e "/^AC_INIT/s/.in/.ac/" -i configure.in || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable osc)
}
