# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cpuinfo-collection/cpuinfo-collection-20070104.ebuild,v 1.3 2012/12/16 22:32:10 ulm Exp $

MY_P=test_proc-${PV:6:2}January${PV:0:4}
DESCRIPTION="huge collection of /proc/cpuinfo files"
HOMEPAGE="http://www.deater.net/weave/vmwprod/linux_logo/"
SRC_URI="http://www.deater.net/weave/vmwprod/linux_logo/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/cpuinfo
	doins -r * || die
}
