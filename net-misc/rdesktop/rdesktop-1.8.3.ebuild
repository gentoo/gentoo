# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/rdesktop/rdesktop-1.8.3.ebuild,v 1.10 2015/02/28 14:11:52 ago Exp $

EAPI=5

inherit autotools eutils

MY_PV=${PV/_/-}

DESCRIPTION="A Remote Desktop Protocol Client"
HOMEPAGE="http://rdesktop.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="alsa ao debug ipv6 kerberos libsamplerate oss pcsc-lite"

S=${WORKDIR}/${PN}-${MY_PV}

RDEPEND=">=dev-libs/openssl-0.9.6b
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXau
	x11-libs/libXdmcp
	alsa? ( media-libs/alsa-lib )
	ao? ( >=media-libs/libao-0.8.6 )
	kerberos? ( net-libs/libgssglue )
	libsamplerate? ( media-libs/libsamplerate )
	pcsc-lite? ( >=sys-apps/pcsc-lite-1.6.6 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-libs/libXt"

src_prepare() {
	# Prevent automatic stripping
	local strip="$(echo '$(STRIP) $(DESTDIR)$(bindir)/rdesktop')"
	sed -i -e "s:${strip}::" Makefile.in \
		|| die "sed failed in Makefile.in"

	# Automagic dependency on libsamplerate
	epatch "${FILESDIR}"/${PN}-1.6.0-sound_configure.patch
	# bug #280923
	epatch "${FILESDIR}"/${PN}-1.7.0-libao_crash.patch

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
		$(use_enable kerberos credssp) \
		$(use_enable pcsc-lite smartcard) \
		${sound_conf}
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc doc/HACKING doc/TODO doc/keymapping.txt
}
