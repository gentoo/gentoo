# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/grutatxt/grutatxt-2.0.16-r1.ebuild,v 1.1 2014/10/19 20:08:39 dilfridge Exp $

EAPI=5

GENTOO_DEPEND_ON_PERL_SUBSLOT=yes
inherit perl-app

MY_PN="Grutatxt"
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A converter from plain text to HTML and other markup languages"
HOMEPAGE="http://triptico.com/software/grutatxt.html"
SRC_URI="http://www.triptico.com/download/${MY_P}.tar.gz"
LICENSE="GPL-2"

IUSE=""
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-linux ~ppc-macos ~sparc-solaris"

# set the script path to /usr/bin, rather than /usr/local/bin
myconf="INSTALLSCRIPT=${EPREFIX}/usr/bin"
