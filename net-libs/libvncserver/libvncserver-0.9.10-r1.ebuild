# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools multilib-minimal

DESCRIPTION="library for creating vnc servers"
HOMEPAGE="http://libvncserver.sourceforge.net/"
SRC_URI="https://github.com/LibVNC/libvncserver/archive/LibVNCServer-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
IUSE="+24bpp gcrypt gnutls ipv6 +jpeg +png ssl static-libs test threads vaapi +zlib"

DEPEND="
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0[${MULTILIB_USEDEP}] )
	gnutls? (
		>=net-libs/gnutls-2.12.23-r6[${MULTILIB_USEDEP}]
		>=dev-libs/libgcrypt-1.5.3:0[${MULTILIB_USEDEP}]
	)
	!gnutls? (
		ssl? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] )
	)
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0[${MULTILIB_USEDEP}] )
	vaapi? ( >=x11-libs/libva-1.2.1-r1[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}-LibVNCServer-${PV}

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	# https://github.com/LibVNC/libvncserver/issues/11
	epatch "${FILESDIR}/${P}-libva-1.0.patch"

	sed -i -r \
		-e "/^SUBDIRS/s:\<$(usex test 'test|' '')client_examples|examples\>::g" \
		Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--disable-silent-rules \
		$(use_enable static-libs static) \
		$(use_with 24bpp) \
		$(use_with gnutls) \
		$(usex gnutls --with-gcrypt $(use_with gcrypt)) \
		$(usex gnutls --without-ssl $(use_with ssl)) \
		$(use_with ipv6) \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_with threads pthread) \
		$(use_with vaapi libva) \
		$(use_with zlib)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
