# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils flag-o-matic

MY_P=${P}3

DESCRIPTION="Ben Fennema's tools for packet writing and the UDF filesystem"
HOMEPAGE="https://sourceforge.net/projects/linux-udf/"
SRC_URI="mirror://sourceforge/linux-udf/${MY_P}.tar.gz
	http://w1.894.telia.com/~u89404340/patches/packet/${MY_P}.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE=""

RDEPEND="sys-libs/readline"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# For new kernel packet writing driver
	epatch "${WORKDIR}"/${MY_P}.patch
	epatch "${FILESDIR}"/cdrwtool-linux2.6-fix-v2.patch
	epatch "${FILESDIR}"/${P}-gcc4.patch #112122
	epatch "${FILESDIR}"/${P}-bigendian.patch #120245
	epatch "${FILESDIR}"/${P}-openflags.patch #232100
	epatch "${FILESDIR}"/${P}-limits_h.patch
	# Force older C standard as the code relies on static inline behavior. #548324
	append-flags -std=gnu89
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog
	newinitd "${FILESDIR}"/pktcdvd.init pktcdvd
	dosym /usr/bin/udffsck /usr/sbin/fsck.udf
}
