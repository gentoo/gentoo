# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit flag-o-matic

DESCRIPTION="protects hosts from brute force attacks against ssh"
HOMEPAGE="http://sshguard.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE="ipfilter kernel_FreeBSD kernel_linux"

CDEPEND="kernel_linux? ( net-firewall/iptables )
	kernel_FreeBSD? ( !ipfilter? ( sys-freebsd/freebsd-pf ) )"
DEPEND="${CDEPEND}
	sys-devel/flex"
RDEPEND="${CDEPEND}
	sys-apps/openrc
	virtual/logger"

src_prepare() {
	sed -i configure -e '/OPTIMIZER_CFLAGS=/d' || die
}

src_configure() {
	# Needed for usleep(3), see "nasty" in src/sshguard_logsuck.c
	append-flags -D_BSD_SOURCE

	local myconf
	if use kernel_linux; then
		myconf="--with-firewall=iptables"
	elif use kernel_FreeBSD; then
		use ipfilter && myconf="--with-firewall=ipfw" \
			|| myconf="--with-firewall=pf"
	fi

	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die
	newconfd "${FILESDIR}"/${PN}.confd ${PN} || die
	dodoc README Changes scripts/sshguard_backendgen.sh examples/* || die
}
