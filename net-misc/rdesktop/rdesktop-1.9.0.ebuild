# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools eutils

MY_PV=${PV/_/-}

DESCRIPTION="A Remote Desktop Protocol Client"
HOMEPAGE="http://www.rdesktop.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="alsa ao ipv6 kerberos oss pcsc-lite pulseaudio xrandr"

S=${WORKDIR}/${PN}-${MY_PV}

RDEPEND="
	dev-libs/nettle:0=
	>=net-libs/gnutls-3.2.0:0=
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXau
	x11-libs/libXdmcp
	alsa? (
		media-libs/alsa-lib
		media-libs/libsamplerate
	)
	ao? (
		>=media-libs/libao-0.8.6
		media-libs/libsamplerate
	)
	kerberos? ( virtual/krb5 )
	pcsc-lite? ( >=sys-apps/pcsc-lite-1.6.6 )
	oss? ( media-libs/libsamplerate )
	pulseaudio? (
		media-libs/libsamplerate
		media-sound/pulseaudio
	)
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}
	x11-libs/libXt"
BDEPEND=virtual/pkgconfig

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.3-no_strip.patch
	"${FILESDIR}"/${PN}-1.8.3-xrandr_configure.patch
)

DOCS=( doc/ChangeLog doc/HACKING doc/TODO doc/keymapping.txt )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	if use pulseaudio; then
		sound_conf="--with-sound=pulse"
	elif use ao; then
		sound_conf="--with-sound=libao"
	elif use alsa; then
		sound_conf="--with-sound=alsa"
	else
		sound_conf=$(use_with oss sound oss)
	fi

	econf \
		$(use_with ipv6) \
		$(use_with xrandr) \
		$(use_enable kerberos credssp) \
		$(use_enable pcsc-lite smartcard) \
		${sound_conf}
}
