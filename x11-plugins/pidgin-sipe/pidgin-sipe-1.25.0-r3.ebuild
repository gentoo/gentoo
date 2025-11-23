# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Pidgin Plug-in SIPE (Sip Exchange Protocol)"
HOMEPAGE="https://sipe.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/sipe/${P}.tar.gz"

inherit autotools

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="dbus debug kerberos ocs2005-message-hack openssl telepathy test voice"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/gmime:2.6
	dev-libs/libxml2:=
	net-im/pidgin[dbus?]
	kerberos? ( virtual/krb5 )
	openssl? ( dev-libs/openssl:= )
	!openssl? ( dev-libs/nss )
	test? ( dev-libs/appstream )
	telepathy? (
		>=sys-apps/dbus-1.1.0
		>=dev-libs/dbus-glib-0.61
		>=dev-libs/glib-2.28:2
		>=net-libs/telepathy-glib-0.18.0
	)
	voice? (
		>=dev-libs/glib-2.28.0
		>=net-libs/libnice-0.1.0
		media-libs/gstreamer:1.0
		net-libs/farstream:0.2
	)
	!voice? (
		>=dev-libs/glib-2.12.0:2
	)
"

DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.25.0-bashisms.patch
	"${FILESDIR}"/${PN}-1.25.0-libxml2.patch
	"${FILESDIR}"/${PN}-1.25.0-appstreamcli.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-purple
		--disable-quality-check
		$(use_enable telepathy)
		$(use_enable debug)
		$(use_enable ocs2005-message-hack)
		$(use_with dbus)
		$(use_with kerberos krb5)
		$(use_with voice vv)
		$(use_enable !openssl nss)
		$(use_enable openssl)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog NEWS TODO README

	find "${ED}" -type f -name "*.la" -delete || die
}
