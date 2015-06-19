# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/linux-gazette-all/linux-gazette-all-182.ebuild,v 1.2 2014/06/08 17:21:49 ulm Exp $

DESCRIPTION="Linux Gazette - all issues"
HOMEPAGE="http://linuxgazette.net/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND=$(eval echo =app-doc/linux-gazette-{0{1,9},{10..${PV}}})
