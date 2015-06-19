# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdoc/kdoc-2.0_alpha54.ebuild,v 1.20 2010/01/08 21:31:37 abcd Exp $

MY_P=${P/_alph/}

DESCRIPTION="C++ and IDL Source Documentation System"
HOMEPAGE="http://www.ph.unimelb.edu.au/~ssk/kde/kdoc/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE=""

DEPEND="dev-lang/perl"

RESTRICT="test" #279709

S=${WORKDIR}/${MY_P}

src_install() {
	use prefix || ED="${D}"
	emake DESTDIR="${D}" install || die
	dodoc README TODO
	rm -rf "${ED}"/usr/share/doc/kdoc
}
