# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit apache-module

DESCRIPTION="Limit the number of simultaneous apache connections"
HOMEPAGE="https://dominia.org/djao/limitipconn2.html"
SRC_URI="https://dominia.org/djao/limit/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND="www-servers/apache[apache2_modules_status]"
need_apache2

RESTRICT="test"

APACHE2_MOD_CONF="27_${PN}"
APACHE2_MOD_DEFINE="LIMITIPCONN STATUS"

DOCFILES="ChangeLog README"
