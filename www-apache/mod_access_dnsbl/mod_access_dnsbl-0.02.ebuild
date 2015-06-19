# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_access_dnsbl/mod_access_dnsbl-0.02.ebuild,v 1.1 2014/12/17 20:22:36 mjo Exp $

EAPI=5

inherit apache-module

DESCRIPTION="Specify access controls based on DNSBL zones"
HOMEPAGE="http://www.apacheconsultancy.com/modules/${PN}/"
SRC_URI="http://www.apacheconsultancy.com/modules/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="www-apache/mod_dnsbl_lookup"
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="DNSBL"

need_apache2
