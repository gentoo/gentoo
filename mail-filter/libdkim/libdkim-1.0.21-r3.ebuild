# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils eutils toolchain-funcs

DESCRIPTION="DomainKeys Identified Mail library from Alt-N Inc"
HOMEPAGE="http://libdkim.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="Apache-2.0 yahoo-patent-license-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl static-libs"

DEPEND="
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	app-arch/unzip"
RDEPEND="
	!mail-filter/libdkim-exim
	dev-libs/openssl"

S="${WORKDIR}/${PN}/src"

src_prepare() {
	ecvs_clean
	cp  "${FILESDIR}"/debianize/* "${S}"
	epatch "${FILESDIR}"/patches/*.patch
	epatch "${FILESDIR}"/libdkim-extra-options.patch

	# Bug 476772
	if ! use static-libs; then
		 sed -i \
			-e '/^TARGETS/s/libdkim.a//' \
			-e '/install -m 644 libdkim.a/d' \
			Makefile.in || die 'sed on Makefile.in failed'
	fi

	# Bug 476770
	tc-export AR

	autotools-utils_src_prepare
}

src_install() {
	autotools-utils_src_install
	dodoc ../README
}
