# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools eutils multilib-minimal

MY_PN="LibVNCServer"

DESCRIPTION="library for creating vnc servers"
HOMEPAGE="https://libvnc.github.io/"
SRC_URI="https://github.com/LibVNC/${PN}/archive/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
# No sub slot wanted (yet), see #578958
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
IUSE="+24bpp gcrypt gnutls ipv6 +jpeg libressl +png ssl static-libs systemd test +threads +zlib"
REQUIRED_USE="!gnutls? ( ssl? ( threads ) )"

DEPEND="
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}] )
	gnutls? (
		>=net-libs/gnutls-2.12.23-r6:0=[${MULTILIB_USEDEP}]
		>=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}]
	)
	!gnutls? (
		ssl? (
			!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}] )
			libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
		)
	)
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}] )
	systemd? ( sys-apps/systemd:= )
	zlib? ( >=sys-libs/zlib-1.2.8-r1:0=[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PN}-${PV}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	default

	sed -i -r \
		-e "/^SUBDIRS/s:\<$(usex test '' 'test|')client_examples|examples\>::g" \
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
		$(use_with zlib)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
