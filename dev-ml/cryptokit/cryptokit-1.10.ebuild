# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Cryptographic primitives library for Objective Caml"
HOMEPAGE="http://forge.ocamlcore.org/projects/cryptokit/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1493/${P}.tar.gz"
LICENSE="LGPL-2"
SLOT="0/${PV}"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="zlib"

DEPEND="zlib? ( >=sys-libs/zlib-1.1 )"
RDEPEND="${DEPEND}"

DOCS=( "Changes" "README.txt" "AUTHORS.txt" )

src_configure() {
	oasis_configure_opts="$(use_enable zlib)" \
		oasis_src_configure
}

pkg_postinst() {
	elog ""
	elog "This library uses the /dev/random device to generate "
	elog "random data and RSA keys.  The device should either be"
	elog "built into the kernel or provided as a module. An"
	elog "alternative is to use the Entropy Gathering Daemon"
	elog "(http://egd.sourceforge.net).  Please note that the"
	elog "remainder of the library will still work even in the"
	elog "absence of a one of these sources of randomness."
	elog ""
}

src_test() {
	echo ""
	einfo "You must have either /dev/random or the Entropy Gathering"
	einfo "Daemon (EGD) for this test to succeed!"
	echo ""

	oasis_src_test
}
