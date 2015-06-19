# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libsigrok/libsigrok-0.3.0.ebuild,v 1.2 2014/06/14 06:08:52 vapier Exp $

EAPI="5"

inherit eutils autotools

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-2 autotools
else
	SRC_URI="http://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="provide basic hardware drivers for logic analyzers and input/output file format support"
HOMEPAGE="http://sigrok.org/wiki/Libsigrok"

LICENSE="GPL-3"
SLOT="0"
IUSE="ftdi serial static-libs test usb"

# We also support librevisa, but that isn't in the tree ...
LIB_DEPEND=">=dev-libs/glib-2.32.0[static-libs(+)]
	>=dev-libs/libzip-0.8[static-libs(+)]
	ftdi? ( >=dev-embedded/libftdi-0.16[static-libs(+)] )
	serial? ( dev-libs/libserialport[static-libs(+)] )
	usb? ( virtual/libusb:1[static-libs(+)] )"
RDEPEND="!static-libs? ( ${LIB_DEPEND//\[static-libs(+)]} )
	static-libs? ( ${LIB_DEPEND} )"
DEPEND="${LIB_DEPEND//\[static-libs(+)]}
	test? ( >=dev-libs/check-0.9.4 )
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.3.0-configure-flags.patch
	epatch "${FILESDIR}"/${PN}-0.3.0-no-check-linkage.patch
	eautoreconf

	# Deal with libftdi-0.x & libftdi-1.x changes.
	if has_version '>=dev-embedded/libftdi-1' ; then
		sed -i 's:libftdi >= 0.16:libftdi1 >= 0.16:g' configure || die
	fi

	# Fix implicit decl w/usleep.
	sed -i '1i#include <unistd.h>' hardware/asix-sigma/asix-sigma.c || die
}

src_configure() {
	econf \
		$(use_enable ftdi libftdi) \
		$(use_enable serial libserialport) \
		$(use_enable usb libusb) \
		$(use_enable static-libs static)
}

src_test() {
	emake check
}

src_install() {
	default
	prune_libtool_files
}
