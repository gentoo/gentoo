# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A console based XMPP client inspired by Irssi"
HOMEPAGE="https://profanity-im.github.io"
SRC_URI="https://profanity-im.github.io/tarballs/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

IUSE="libnotify omemo otr gpg test xscreensaver"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-db/sqlite:3
	dev-libs/atk
	dev-libs/glib:2
	dev-libs/libassuan
	dev-libs/libgpg-error
	>=dev-libs/libstrophe-0.11.0
	net-misc/curl
	sys-libs/ncurses:=[unicode(+)]
	virtual/libcrypt:=
	media-libs/harfbuzz:=
	gpg? ( app-crypt/gpgme:= )
	libnotify? ( x11-libs/libnotify )
	omemo? (
		net-libs/libsignal-protocol-c
		dev-libs/libgcrypt:=
	)
	otr? ( net-libs/libotr )
	sys-libs/readline:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
	xscreensaver? (
		x11-libs/libXScrnSaver
		x11-libs/libX11
	)
"
DEPEND="
	${COMMON_DEPEND}
	test? ( dev-util/cmocka )
"
RDEPEND="${COMMON_DEPEND}"

src_configure() {
	econf \
		$(use_enable libnotify notifications) \
		$(use_enable omemo) \
		$(use_enable otr) \
		$(use_enable gpg pgp) \
		$(use_with xscreensaver)
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
