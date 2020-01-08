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
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="alsa ao debug ipv6 kerberos libressl libsamplerate oss pcsc-lite xrandr"

S=${WORKDIR}/${PN}-${MY_PV}

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXau
	x11-libs/libXdmcp
	alsa? ( media-libs/alsa-lib )
	ao? ( >=media-libs/libao-0.8.6 )
	kerberos? ( virtual/krb5 )
	libsamplerate? ( media-libs/libsamplerate )
	pcsc-lite? ( >=sys-apps/pcsc-lite-1.6.6 )
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}
	x11-libs/libXt"
BDEPEND=virtual/pkgconfig

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.0-sound_configure.patch
	"${FILESDIR}"/${PN}-1.8.3-no_strip.patch
	"${FILESDIR}"/${PN}-1.8.3-xrandr_configure.patch
	"${FILESDIR}"/${PN}-1.8.4-libressl.patch
	"${FILESDIR}"/${PN}-1.8.5-use_standard_gssapi.patch
	"${FILESDIR}"/${P}-sec_decrypt.patch
)

DOCS=( doc/HACKING doc/TODO doc/keymapping.txt )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	if use ao; then
		sound_conf=$(use_with ao sound libao)
	else if use alsa; then
			sound_conf=$(use_with alsa sound alsa)
		else
			sound_conf=$(use_with oss sound oss)
		fi
	fi

	econf \
		--with-openssl="${EPREFIX}"/usr \
		$(use_with debug) \
		$(use_with ipv6) \
		$(use_with libsamplerate) \
		$(use_with xrandr) \
		$(use_enable kerberos credssp) \
		$(use_enable pcsc-lite smartcard) \
		${sound_conf}
}
