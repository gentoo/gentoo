# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit perl-module

DESCRIPTION="Mozilla PerLDAP"
HOMEPAGE="http://www.mozilla.org/directory/perldap.html"
SRC_URI="https://ftp.mozilla.org/pub/mozilla.org/directory/perldap/releases/${PV}/src/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/nspr-4.0.1
	>=dev-libs/nss-3.11.6
	net-nds/openldap"

DEPEND="
	${RDEPEND}
	sys-apps/sed"

src_configure() {
	export USE_OPENLDAP=1
	perl-module_src_configure
}
