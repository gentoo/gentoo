# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/man-pages-pl/man-pages-pl-20070628-r2.ebuild,v 1.11 2014/08/10 17:50:14 slyfox Exp $

EAPI=4

inherit autotools

DESCRIPTION="A collection of Polish translations of Linux manual pages"
HOMEPAGE="http://www.batnet.pl/ptm/"
SRC_URI="http://www.batnet.pl/ptm/man-PL${PV:6:2}-${PV:4:2}-${PV:0:4}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND=""
DEPEND=""

DOCS=(AUTHORS ChangeLog FAQ NEWS README TODO)

S="${WORKDIR}/pl_PL"

src_prepare() {
	# missing manpages
	sed -i -e '/\tpasswd.1/ d' man1/Makefile.am || die

	# manpages provided by other packages
	mans="gendiff.1 groups.1 apropos.1 man.1 su.1 newgrp.1 whatis.1 gpasswd.1 chsh.1 \
			chfn.1 limits.5 login.1 expiry.1 porttime.5 lastlog.8 faillog.8 logoutd.8 \
			rpm.8 rpmdeps.8 rpmbuild.8 rpmcache.8 rpmgraph.8 rpm2cpio.8 evim.1 vim.1 \
			vimdiff.1 vimtutor.1 ex.1 rview.1 rvim.1 view.1 suauth.5 mc.1"
	# bug #375623:
	mans="${mans} manpath.5 catman.8 mandb.8 zsoelim.1 manpath.1"
	# bug #403379:
	mans="${mans} shadow.3"
	for page in ${mans} ; do
		sed -i -e "/\\t${page}/d; \$s,\\\,,;" man${page: -1}/Makefile.am || die
	done

	eautoreconf
}
