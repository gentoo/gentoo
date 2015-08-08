# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit apache-module

KEYWORDS="~ppc ~x86"

DESCRIPTION="An Apache module to talk to Zope Corporation's PCGI"
HOMEPAGE="http://www.zope.org/Members/phd/mod_pcgi2/"
SRC_URI="http://zope.org/Members/phd/${PN}/${PN}/${P}-src.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="www-apps/pcgi"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN/mod_}"

APXS2_ARGS="-n pcgi2 -DUNIX -DAPACHE2 -DMOD_PCGI2 -c mod_pcgi2.c pcgi-wrapper.c parseinfo.c "

APACHE2_MOD_CONF="20_mod_pcgi"
APACHE2_MOD_DEFINE="PCGI"

DOCFILES="NEWS README ChangeLog"

need_apache
