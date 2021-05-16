# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic git-r3

DESCRIPTION="A framework for layer 2 attacks"
HOMEPAGE="https://github.com/tomac/yersinia"
EGIT_REPO_URI="https://github.com/tomac/yersinia"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gtk ncurses"

RDEPEND="
	ncurses? ( >=sys-libs/ncurses-5.5:= )
	gtk? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf
		=x11-libs/gtk+-2*
	)
	>=net-libs/libnet-1.1.2
	>=net-libs/libpcap-0.9.4
"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"
DOCS=( AUTHORS ChangeLog FAQ README THANKS TODO )
PATCHES=(
	"${FILESDIR}"/${PN}-0.7.1-no-ncurses.patch
	"${FILESDIR}"/${PN}-9999-tinfo.patch
)

src_prepare() {
	default

	if ! use gtk; then
		#bug #514802
		sed -i -e '/AM_GLIB_GNU_GETTEXT/d' configure.in || die
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
