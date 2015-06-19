# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/inputlircd/inputlircd-0.0.1_pre11.ebuild,v 1.11 2009/11/16 10:56:35 zzam Exp $

DESCRIPTION="Inputlirc daemon to utilize /dev/input/event*"
HOMEPAGE="http://svn.sliepen.eu.org/inputlirc/trunk"
SRC_URI="http://gentooexperimental.org/~genstef/dist/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install || die "emake install failed"

	newinitd "${FILESDIR}"/inputlircd.init  inputlircd
	newconfd "${FILESDIR}"/inputlircd.conf  inputlircd
}
