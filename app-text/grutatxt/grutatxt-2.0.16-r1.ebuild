# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

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
