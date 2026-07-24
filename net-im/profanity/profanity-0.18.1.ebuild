# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit flag-o-matic meson python-single-r1

DESCRIPTION="A console based XMPP client inspired by Irssi"
HOMEPAGE="https://profanity-im.github.io"
SRC_URI="https://github.com/profanity-im/profanity/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="gpg gtk libnotify omemo omemo-qrcode otr python spell test xscreensaver"
RESTRICT="!test? ( test )"
REQUIRED_USE="omemo-qrcode? ( omemo ) python? ( ${PYTHON_REQUIRED_USE} )"

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
	x11-libs/pango
	x11-misc/shared-mime-info
	gpg? ( app-crypt/gpgme:= )
	gtk? ( x11-libs/gtk+:3 )
	libnotify? ( x11-libs/libnotify )
	omemo? (
		dev-libs/libgcrypt:=
		net-libs/libomemo-c
	)
	omemo-qrcode? ( media-gfx/qrencode:= )
	otr? ( net-libs/libotr )
	python? ( ${PYTHON_DEPS} )
	spell? ( app-text/enchant:2 )
	xscreensaver? (
		x11-libs/libXScrnSaver
		x11-libs/libX11
	)
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )
	python? (
		$(python_gen_cond_dep '
			dev-python/cython[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	filter-lto

	local emesonargs=(
		-Dgdk-pixbuf=enabled
		-Dicons-and-clipboard=$(usex gtk enabled disabled)
		-Dnotifications=$(usex libnotify enabled disabled)
		-Domemo=$(usex omemo enabled disabled)
		-Domemo-backend=libomemo-c
		-Domemo-qrcode=$(usex omemo-qrcode enabled disabled)
		-Dotr=$(usex otr enabled disabled)
		-Dpython-plugins=$(usex python enabled disabled)
		-Dpgp=$(usex gpg enabled disabled)
		-Dspellcheck=$(usex spell enabled disabled)
		-Dtests=$(usex test true false)
		-Dxscreensaver=$(usex xscreensaver enabled disabled)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	mv "${ED}"/usr/share/doc/${PN}/* "${ED}"/usr/share/doc/${PF} || die
	rmdir "${ED}"/usr/share/doc/${PN} || die
}
