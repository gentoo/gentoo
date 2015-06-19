# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_xsendfile/mod_xsendfile-1.0_beta1.ebuild,v 1.5 2015/01/02 12:15:54 ago Exp $

EAPI="4"

inherit apache-module

MY_PV="1.0b1"
DESCRIPTION="Apache2 module that processes X-SENDFILE headers registered by the original output handler"
HOMEPAGE="https://tn123.org/mod_xsendfile/"
SRC_URI="https://tn123.org/mod_xsendfile/beta/${PN}-${MY_PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 sparc x86 ~amd64-linux"
IUSE=""

S=${WORKDIR}

RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="50_${PN}"
APACHE2_MOD_DEFINE="XSENDFILE"

DOCFILES="docs/Readme.html"

need_apache2
