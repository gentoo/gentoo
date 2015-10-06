# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit apache-module eutils systemd

DESCRIPTION="An Apache authentication module using Kerberos"
HOMEPAGE="http://modauthkerb.sourceforge.net/"
SRC_URI="mirror://sourceforge/modauthkerb/${P}.tar.gz"

LICENSE="BSD openafs-krb5-a HPND"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/krb5"
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="11_${PN}"
APACHE2_MOD_DEFINE="AUTH_KERB"

DOCFILES="INSTALL README"

need_apache2

src_prepare() {
	epatch "${FILESDIR}"/${P}-rcopshack.patch
	epatch "${FILESDIR}"/${P}-fixes.patch
	epatch "${FILESDIR}"/${P}-s4u2proxy-r3.patch
	epatch "${FILESDIR}"/${P}-httpd24.patch
	epatch "${FILESDIR}"/${P}-delegation.patch
	epatch "${FILESDIR}"/${P}-cachedir.patch
	epatch "${FILESDIR}"/${P}-longuser.patch
	epatch "${FILESDIR}"/${P}-handle-continue.patch
}

src_configure() {
	CFLAGS="" APXS="${APXS}" econf --with-krb5=/usr --without-krb4
}

src_compile() {
	emake
}

src_install() {
	apache-module_src_install
	systemd_dotmpfilesd "${FILESDIR}/${PN}.conf"
}
