# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
