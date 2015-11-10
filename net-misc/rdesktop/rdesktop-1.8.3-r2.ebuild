# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

MY_PV=${PV/_/-}

DESCRIPTION="A Remote Desktop Protocol Client"
HOMEPAGE="http://rdesktop.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
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
	kerberos? ( net-libs/libgssglue )
	libsamplerate? ( media-libs/libsamplerate )
	pcsc-lite? ( >=sys-apps/pcsc-lite-1.6.6 )
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-libs/libXt"

src_prepare() {
	# Prevent automatic stripping
	local strip="$(echo '$(STRIP) $(DESTDIR)$(bindir)/rdesktop')"
	sed -i -e "s:${strip}::" Makefile.in \
		|| die "sed failed in Makefile.in"

	# Automagic dependencies
	epatch "${FILESDIR}"/${PN}-1.6.0-sound_configure.patch
	epatch "${FILESDIR}"/${P}-xrandr_configure.patch

	epatch_user

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

src_install() {
	emake DESTDIR="${D}" install
	dodoc doc/HACKING doc/TODO doc/keymapping.txt
}
