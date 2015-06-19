# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_dnsbl_lookup/mod_dnsbl_lookup-0.91.ebuild,v 1.2 2008/01/31 16:41:13 hollow Exp $

inherit apache-module eutils

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A helper module for Apache2 providing DNSBL lookup"
HOMEPAGE="http://www.sysdesign.ca"
SRC_URI="http://www.sysdesign.ca/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="09_${PN}"
APACHE2_MOD_DEFINE="DNSBL"

need_apache2

src_install() {
	apache-module_src_install
	insinto $(${APXS} -q INCLUDEDIR)
	doins dnsbl_lookup.h
}
