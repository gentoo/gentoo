# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Pidgin Plug-in SIPE (Sip Exchange Protocol)"
HOMEPAGE="https://sipe.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/sipe/${P}.tar.gz"

inherit autotools

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="dbus debug kerberos ocs2005-message-hack openssl test voice"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.18.0:2
	dev-libs/gmime:3.0
	dev-libs/libxml2:=
	net-im/pidgin
	dbus? (
		net-im/pidgin[dbus]
		sys-apps/dbus
	)
	kerberos? ( virtual/krb5 )
	openssl? ( dev-libs/openssl:= )
	!openssl? (
		dev-libs/nspr
		dev-libs/nss
	)
	voice? (
		>=net-libs/libnice-0.1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gstreamer:1.0
		net-im/pidgin[v4l]
		net-libs/farstream:0.2
	)
"

DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-libs/appstream )
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
		--disable-telepathy
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
	einstalldocs

	find "${ED}" -type f -name "*.la" -delete || die
}
