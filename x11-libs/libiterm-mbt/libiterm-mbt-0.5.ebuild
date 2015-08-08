# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Hacked version of libiterm -- Internationalized Terminal Emulator Library"
HOMEPAGE="http://www.doc.ic.ac.uk/~mbt99/Y/
	http://www-124.ibm.com/linux/projects/iterm/"
SRC_URI="http://www.doc.ic.ac.uk/~mbt99/Y/src/iterm-${PV}-mbt.tar.gz"
LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"

IUSE=""

S=${WORKDIR}/iterm-${PV}-mbt/lib/

src_compile() {
	econf || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README INSTALL
}
