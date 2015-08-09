# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

MY_P=netkit-ntalk-${PV}
S=${WORKDIR}/netkit-ntalk-${PV}

DESCRIPTION="Netkit - talkd"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="ipv6"

COMMON_DEPEND=">=sys-libs/ncurses-5.2"
DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
"
RDEPEND="
	${COMMON_DEPEND}
	virtual/inetd
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-time.patch
	use ipv6 && epatch "${FILESDIR}"/${P}-ipv6.diff
	sed -i configure -e '/^LDFLAGS=/d' || die
}

src_configure() {
	# not autotools based?
	./configure --with-c-compiler=$(tc-getCC) || die
}

src_compile() {
	emake LIBCURSES="$( $(tc-getPKG_CONFIG) --libs ncurses )"
}

src_install() {
	insinto /etc/xinetd.d
	newins "${FILESDIR}"/talk.xinetd talk
	dobin talk/talk
	doman talk/talk.1
	dosbin talkd/talkd
	dosym talkd /usr/sbin/in.talkd
	doman talkd/talkd.8
	dosym talkd.8 /usr/share/man/man8/in.talkd.8
	dodoc README ChangeLog BUGS
}
