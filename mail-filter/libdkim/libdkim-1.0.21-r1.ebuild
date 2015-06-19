# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/libdkim/libdkim-1.0.21-r1.ebuild,v 1.4 2014/08/10 21:16:12 slyfox Exp $

EAPI="4"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit eutils autotools-utils

DESCRIPTION="DomainKeys Identified Mail library from Alt-N Inc"
HOMEPAGE="http://libdkim.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="Apache-2.0 yahoo-patent-license-1.2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/openssl
	app-arch/unzip"
RDEPEND="!mail-filter/libdkim-exim
	dev-libs/openssl"

S="${WORKDIR}/${PN}/src"

src_prepare() {
	ecvs_clean
	cp  "${FILESDIR}"/debianize/* "${S}"
	epatch "${FILESDIR}"/patches/*.patch
	epatch "${FILESDIR}"/libdkim-extra-options.patch
	autotools-utils_src_prepare

}

src_install() {
	autotools-utils_src_install
	dodoc ../README
}
