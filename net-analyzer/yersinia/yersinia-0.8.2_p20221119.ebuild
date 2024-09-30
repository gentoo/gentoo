# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="A framework for layer 2 attacks"
HOMEPAGE="http://www.yersinia.net/"
#SRC_URI="https://github.com/tomac/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
COMMIT="867b309eced9e02b63412855440cd4f5f7727431"
SRC_URI="https://github.com/tomac/yersinia/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk ncurses"

RDEPEND="
	>=net-libs/libnet-1.1.2:1.1
	>=net-libs/libpcap-0.9.4
	ncurses? ( >=sys-libs/ncurses-5.5:= )
	gtk? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
		=x11-libs/gtk+-2*:2
		x11-libs/pango
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog FAQ README THANKS TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.1-no-ncurses.patch
	"${FILESDIR}"/${PN}-0.7.3-tinfo.patch
)

src_prepare() {
	default

	if ! use gtk; then
		# bug #514802
		sed -i -e '/AM_GLIB_GNU_GETTEXT/d' configure.ac || die
	fi

	eautoreconf
}

src_configure() {
	append-cflags -fcommon

	econf \
		--enable-admin \
		--with-pcap-includes=/usr/include \
		$(use_with ncurses) \
		$(use_enable gtk)
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}
