# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/linux-device-drivers/linux-device-drivers-3.ebuild,v 1.5 2013/02/07 21:30:16 ulm Exp $

DESCRIPTION="howto write linux device drivers (updated for Linux 2.6)"
HOMEPAGE="http://www.oreilly.com/catalog/linuxdrive3/ http://lwn.net/Kernel/LDD3/"
SRC_URI="http://lwn.net/images/pdf/LDD3/ldd3_pdf.tar.bz2
	mirror://gentoo/LDD3-examples.tar.gz"
# original URL is this:
# http://examples.oreilly.com/linuxdrive3/examples.tar.gz
# but 'examples.tar.gz' is waaaaaay too generic

LICENSE="CC-BY-SA-2.0"
SLOT="3"
KEYWORDS="amd64 arm hppa ia64 ppc s390 sh x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_install() {
	insinto /usr/share/doc/${PF}
	doins ldd3_pdf/*.pdf || die "pdfs"
	insinto /usr/share/doc/${PF}/examples
	doins -r examples/* || die "examples"
}
