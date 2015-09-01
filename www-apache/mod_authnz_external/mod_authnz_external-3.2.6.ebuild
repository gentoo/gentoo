# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils apache-module

DESCRIPTION="An Apache2 authentication DSO using external programs"
HOMEPAGE="https://github.com/phokz/mod-auth-external"
SRC_URI="https://mod-auth-external.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="2"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

DOCFILES="AUTHENTICATORS CHANGES INSTALL INSTALL.HARDCODE README TODO UPGRADE"

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="AUTHNZ_EXTERNAL"

need_apache2_2
