# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/memtester/memtester-4.3.0.ebuild,v 1.6 2014/03/15 21:39:36 mattst88 Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="userspace utility for testing the memory subsystem for faults"
HOMEPAGE="http://pyropus.ca/software/memtester/"
SRC_URI="http://pyropus.ca/software/memtester/${P}.tar.gz
	http://pyropus.ca/software/memtester/old-versions/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

src_prepare() {
	echo "$(tc-getCC) ${CFLAGS} ${CPPFLAGS} -DPOSIX -c" > conf-cc
	echo "$(tc-getCC) ${CFLAGS} ${LDFLAGS}" > conf-ld
}

src_install() {
	dosbin memtester
	doman memtester.8
	dodoc BUGS CHANGELOG README README.tests
}
