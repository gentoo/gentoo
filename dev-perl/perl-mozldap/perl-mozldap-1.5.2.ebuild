# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Mozilla PerLDAP"
HOMEPAGE="http://www.mozilla.org/directory/perldap.html"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/directory/perldap/releases/${PV}/src/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/nspr-4.0.1
	>=dev-libs/nss-3.11.6
	>=dev-libs/mozldap-6.0.1"
DEPEND="${RDEPEND}
	sys-apps/sed"

src_prepare () {
	sed -e "s!mozldap6!mozldap!g" -i Makefile.PL.rpm || die
	mv Makefile.PL.rpm Makefile.PL || die
	perl-module_src_prepare
}
