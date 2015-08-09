# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="A VNC server for real X displays"
HOMEPAGE="http://www.karlrunge.com/x11vnc/"
SRC_URI="mirror://sourceforge/libvncserver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="avahi crypt fbcon +jpeg ssl system-libvncserver threads tk xinerama +zlib"

RDEPEND="
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libX11
	>=x11-libs/libXtst-1.1.0
	x11-libs/libXdamage
	x11-libs/libXext
	avahi? ( >=net-dns/avahi-0.6.4 )
	ssl? ( dev-libs/openssl )
	system-libvncserver? ( >=net-libs/libvncserver-0.9.7[threads=,jpeg=,zlib=] )
	!system-libvncserver? (
		zlib? ( sys-libs/zlib )
		jpeg? ( virtual/jpeg:0 )
	)
	tk? ( dev-lang/tk )
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	x11-libs/libXt
	x11-proto/inputproto
	x11-proto/trapproto
	x11-proto/recordproto
	x11-proto/xproto
	x11-proto/xextproto
	xinerama? ( x11-proto/xineramaproto )"

pkg_setup() {
	if use avahi && ! use threads ; then
		ewarn "Non-native avahi support has been enabled."
		ewarn "Native avahi support can be enabled by also enabling the threads USE flag."
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-warnings.patch \
		"${FILESDIR}"/${P}-shm-cleanup.patch
}

src_configure() {
	# --without-v4l because of missing video4linux 2.x support wrt #389079
	econf \
		$(use_with system-libvncserver) \
		$(use_with xinerama) \
		--without-v4l \
		$(use_with fbcon fbdev) \
		$(use_with crypt) \
		$(use_with ssl crypto) \
		$(use_with ssl) \
		$(use_with avahi) \
		$(use_with jpeg) \
		$(use_with zlib) \
		$(use_with threads pthread)
}

src_install() {
	default
	dodoc x11vnc/{ChangeLog,README}
	# Remove include files, which conflict with net-libs/libvncserver
	rm -rf "${ED%/}"/usr/include
}
