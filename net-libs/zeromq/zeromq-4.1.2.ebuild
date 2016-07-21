# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="A brokerless kernel"
HOMEPAGE="http://www.zeromq.org/"
SRC_URI="http://download.zeromq.org/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/5"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="pgm static-libs test"

RDEPEND="
	dev-libs/libsodium:=
	pgm? ( =net-libs/openpgm-5.2.122 )"
DEPEND="${RDEPEND}
	sys-apps/util-linux
	pgm? ( virtual/pkgconfig )"

src_prepare() {
	einfo "Removing bundled OpenPGM library"
	rm -fr "${S}"/foreign/openpgm/libpgm* || die
	sed \
		-e '/libzmq_werror=/s:yes:no:g' \
		-i configure.ac || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=()
	use pgm && myeconfargs+=( --with-system-pgm ) || myeconfargs+=( --without-pgm )
	autotools-utils_src_configure
}

src_test() {
	autotools-utils_src_test -j1
}

src_install() {
	autotools-utils_src_install

	doman doc/*.[1-9]
}
