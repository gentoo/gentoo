# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A tool to measure bandwidth and RTT between two hosts using ICMP"
HOMEPAGE="https://bwping.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86 ~x86-fbsd"

src_prepare() {
	default
	eautoreconf
}

src_test() {
	if has userpriv ${FEATURES} ; then
		ewarn "Test suite is disabled, set FEATURES=-userpriv to enable."
	else
		default
	fi
}
