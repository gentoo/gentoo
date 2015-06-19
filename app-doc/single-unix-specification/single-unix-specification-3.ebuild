# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/single-unix-specification/single-unix-specification-3.ebuild,v 1.5 2013/03/30 16:24:23 ulm Exp $

DESCRIPTION="The Single UNIX Specification, Version 3, 2004 Edition (8 Volumes)"
HOMEPAGE="http://www.opengroup.org/bookstore/catalog/t041.htm"
SRC_URI="http://www.opengroup.org/onlinepubs/009695399/download/susv3.tar.bz2"

LICENSE="sus3-copyright"
SLOT="3"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE=""
RESTRICT="mirror"

DEPEND=""

S="${WORKDIR}/susv3"

src_install() {
	insinto /usr/share/doc/${PF}/html
	doins -r * || die "doins"
}
