# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SHAY
MODULE_VERSION=1.27
inherit eutils perl-module

DESCRIPTION="A URI Perl Module"

SLOT="0"
KEYWORDS=""
IUSE="sasl"

RDEPEND="sasl? ( dev-perl/Authen-SASL )"
DEPEND=""

SRC_TEST="do"

src_prepare() {
	cp "${FILESDIR}"/libnet.cfg "${S}"
}
