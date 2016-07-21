# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

MY_P="${PN}-src-${PV}"
DESCRIPTION="Snort plugin that allows automated blocking of IP addresses on several firewalls"
HOMEPAGE="http://www.snortsam.net/"
SRC_URI="http://www.snortsam.net/files/snortsam/${MY_P}.tar.gz
	mirror://gentoo/${PN}-2.50-ciscoacl.diff.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# bug 155955, ciscoacl segfaults with gcc-4.1.1
	epatch "${DISTDIR}"/${PN}-2.50-ciscoacl.diff.bz2
	sed -i -e "s:sbin/functions.sh:etc/init.d/functions.sh:" \
			-e "s: -O2 : ${CFLAGS} :" \
			-e "s:gcc :$(tc-getCC) :" \
			-e "s:\( -o ../snortsam\): ${LDFLAGS}\1:" makesnortsam.sh || die "sed failed"
		ecvs_clean
}

src_compile() {
	sh makesnortsam.sh || die "makesnortsam.sh failed"
}

src_install() {
	dobin snortsam || die "dobin failed"
	find "${S}" -depth -type f -name "*.asc" -exec rm -f {} \;
	dodoc docs/* conf/*
}

pkg_postinst() {
	elog
	elog "To use snortsam with snort, you'll have to compile snort with USE=snortsam."
	elog "Read the INSTALL file to configure snort for snortsam, and configure"
	elog "snortsam for your particular firewall."
	elog
}
