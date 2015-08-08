# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit apache-module eutils

DESCRIPTION="Apache module for a replacement of the CGI protocol, similar to FastCGI"
HOMEPAGE="http://python.ca/scgi/ http://pypi.python.org/pypi/scgi"
SRC_URI="http://python.ca/scgi/releases/scgi-${PV}.tar.gz"

LICENSE="CNRI"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE=""

DEPEND="~www-apps/scgi-${PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/scgi-${PV}"

APXS2_S="${S}/apache2"
APACHE2_MOD_FILE="${S}/apache2/.libs/${PN}.so"
APACHE2_MOD_CONF="20_mod_scgi"
APACHE2_MOD_DEFINE="SCGI"

DOCFILES="PKG-INFO LICENSE.txt CHANGES.txt apache2/README.txt"

need_apache2_4

src_prepare() {
	epatch "${FILESDIR}"/${P}-apache-2.4.patch
}
