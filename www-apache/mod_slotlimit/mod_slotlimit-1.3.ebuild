# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit apache-module

MY_PV=${PV/_/-}
MY_P="mod_slotlimit-${MY_PV}"

DESCRIPTION="manage resources used for each running site using dynamic slot allocation algorithm and static rules"
HOMEPAGE="http://www.lucaercoli.it/en/mod_slotlimit.html"
SRC_URI="http://downloads.sourceforge.net/project/mod-slotlimit/mod-slotlimit/${MY_PV}/${P}.tar.gz"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

# See apache-module.eclass for more information.
APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="SLOTLIMIT"

need_apache2_2
