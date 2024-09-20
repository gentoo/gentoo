# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="A console based XMPP client inspired by Irssi"
HOMEPAGE="https://profanity-im.github.io"
SRC_URI="https://github.com/profanity-im/profanity/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="libnotify omemo omemo-qrcode otr gpg test xscreensaver"
RESTRICT="!test? ( test )"
REQUIRED_USE="omemo-qrcode? ( omemo )"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0
	dev-db/sqlite:3
	dev-libs/glib:2
	>=dev-libs/libstrophe-0.12.3:=
	media-libs/harfbuzz:=
	net-misc/curl
	sys-libs/ncurses:=[unicode(+)]
	sys-libs/readline:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
	x11-misc/shared-mime-info
	gpg? ( app-crypt/gpgme:= )
	libnotify? ( x11-libs/libnotify )
	omemo? (
		dev-libs/libgcrypt:=
		net-libs/libsignal-protocol-c
	)
	omemo-qrcode? ( media-gfx/qrencode:= )
	otr? ( net-libs/libotr )
	xscreensaver? (
		x11-libs/libXScrnSaver
		x11-libs/libX11
	)
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )
"

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/932874
	# https://github.com/profanity-im/profanity/issues/1992
	filter-lto

	local myeconfargs=(
		--enable-gdk-pixbuf
		$(use_enable libnotify notifications)
		$(use_enable omemo)
		$(use_enable omemo-qrcode)
		$(use_enable otr)
		$(use_enable gpg pgp)
		$(use_with xscreensaver)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
