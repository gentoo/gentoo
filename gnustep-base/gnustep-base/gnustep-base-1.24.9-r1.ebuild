# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils gnustep-base versionator

DESCRIPTION="A library of general-purpose, non-graphical Objective C objects"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/$(get_version_component_range 1-2)"
KEYWORDS="~alpha amd64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="+gnutls +icu +libffi libressl +ssl zeroconf"

RDEPEND="${GNUSTEP_CORE_DEPEND}
	>=gnustep-base/gnustep-make-2.6.0
	ssl? (
		gnutls? ( net-libs/gnutls )
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:= )
		)
	)
	icu? ( >=dev-libs/icu-4.0:= )
	!libffi? ( dev-libs/ffcall
		gnustep-base/gnustep-make[-native-exceptions] )
	libffi? ( dev-libs/libffi )
	>=dev-libs/libxml2-2.6
	>=dev-libs/libxslt-1.1
	>=dev-libs/gmp-4.1:=
	>=sys-libs/zlib-1.2
	zeroconf? ( net-dns/avahi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_pretend() {
	if use ssl && use gnutls && use libressl ; then
		ewarn "You have enabled both gnutls and libressl, but only"
		ewarn "one provider can be active. Using gnutls!"
	fi
}

src_configure() {
	egnustep_env

	local myconf
	if use libffi ; then
		myconf="--enable-libffi --disable-ffcall --with-ffi-include=$(pkg-config --variable=includedir libffi)"
	else
		myconf="--disable-libffi --enable-ffcall"
	fi

	if use ssl ; then
		if use gnutls ; then
			myconf="$myconf --enable-tls --disable-openssl"
		else
			myconf="$myconf --disable-tls --enable-openssl"
		fi
	else
		myconf="$myconf --disable-tls --disable-openssl"
	fi
	myconf="$myconf $(use_enable icu)"
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
