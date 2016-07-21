# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit scsh

DESCRIPTION="Installation tool for the Scheme Untergrund Library"
HOMEPAGE="http://lamp.epfl.ch/~schinz/scsh_packages/"
SRC_URI="http://lamp.epfl.ch/~schinz/scsh_packages/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=app-shells/scsh-0.6.6"

src_install() {
	dodir $SCSH_MODULES_PATH
	./install.scm ${SCSH_LAYOUT_CONF} \
	  --bindir /usr/bin \
	  --force \
	  || die "./install.scm failed"
}
