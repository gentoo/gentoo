# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

MY_P="${P/-tpm-/_tpm_}"

DESCRIPTION="This provides a OpenSSL engine that uses private keys stored in TPM hardware"
HOMEPAGE="http://trousers.sourceforge.net"
SRC_URI="mirror://sourceforge/trousers/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RDEPEND=">=dev-libs/openssl-0.9.8:*
	>=app-crypt/trousers-0.2.8"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	mv configure.in configure.ac || die
	epatch "${FILESDIR}/${P}-build.patch"
	eautoreconf
}

src_install() {
	default
	dodoc openssl.cnf.sample
}
