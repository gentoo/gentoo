# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-base/gnustep-base-1.24.7.ebuild,v 1.1 2014/10/20 13:16:57 voyageur Exp $

EAPI=5
inherit eutils gnustep-base

DESCRIPTION="A library of general-purpose, non-graphical Objective C objects"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="+icu +libffi ssl zeroconf"

RDEPEND="${GNUSTEP_CORE_DEPEND}
	>=gnustep-base/gnustep-make-2.6.0
	icu? ( >=dev-libs/icu-4.0:= )
	!libffi? ( dev-libs/ffcall
		gnustep-base/gnustep-make[-native-exceptions] )
	libffi? ( virtual/libffi )
	ssl? ( net-libs/gnutls )
	>=dev-libs/libxml2-2.6
	>=dev-libs/libxslt-1.1
	>=dev-libs/gmp-4.1
	>=dev-libs/openssl-0.9.7
	>=sys-libs/zlib-1.2
	zeroconf? ( net-dns/avahi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	egnustep_env

	local myconf
	if use libffi;
	then
		myconf="--enable-libffi --disable-ffcall --with-ffi-include=$(pkg-config --variable=includedir libffi)"
	else
		myconf="--disable-libffi --enable-ffcall"
	fi

	myconf="$myconf $(use_enable icu)"
	myconf="$myconf $(use_enable ssl tls)"
	myconf="$myconf $(use_enable zeroconf)"
	myconf="$myconf --with-xml-prefix=${EPREFIX}/usr"
	myconf="$myconf --with-gmp-include=${EPREFIX}/usr/include --with-gmp-library=${EPREFIX}/usr/lib"
	myconf="$myconf --with-default-config=${EPREFIX}/etc/GNUstep/GNUstep.conf"

	econf $myconf
}

src_install() {
	# We need to set LD_LIBRARY_PATH because the doc generation program
	# uses the gnustep-base libraries.  Since egnustep_env "cleans the
	# environment" including our LD_LIBRARY_PATH, we're left no choice
	# but doing it like this.

	egnustep_env
	egnustep_install

	if use doc ; then
		export LD_LIBRARY_PATH="${S}/Source/obj:${LD_LIBRARY_PATH}"
		egnustep_doc
	fi
	egnustep_install_config
}
