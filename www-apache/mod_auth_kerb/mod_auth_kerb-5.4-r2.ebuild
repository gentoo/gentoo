# Copyright 1999-2016 Gentoo Foundation
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

PATCHES=(
	"${FILESDIR}"/${P}-rcopshack.patch
	"${FILESDIR}"/${P}-fixes.patch
	"${FILESDIR}"/${P}-s4u2proxy.patch
	"${FILESDIR}"/${P}-httpd24.patch
	"${FILESDIR}"/${P}-delegation.patch
	"${FILESDIR}"/${P}-cachedir.patch
	"${FILESDIR}"/${P}-longuser.patch
	"${FILESDIR}"/${P}-handle-continue.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
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
