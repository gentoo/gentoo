# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_authn_sasl/mod_authn_sasl-1.2.ebuild,v 1.4 2014/12/18 13:20:03 pacho Exp $

inherit eutils apache-module

DESCRIPTION="Cyrus SASL authentication module for Apache"
HOMEPAGE="http://mod-authn-sasl.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/mod-authn-sasl/mod-authn-sasl/${PV}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="dev-libs/cyrus-sasl"
RDEPEND="${DEPEND}"

APXS2_ARGS="-c ${PN}.c -lsasl2"
APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="AUTHN_SASL"

need_apache2

src_install() {
	apache-module_src_install
}
