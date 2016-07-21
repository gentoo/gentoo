# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic

DESCRIPTION="protects hosts from brute force attacks against ssh"
HOMEPAGE="http://sshguard.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="ipfilter kernel_FreeBSD kernel_linux"

CDEPEND="
	kernel_linux? ( net-firewall/iptables )
	kernel_FreeBSD? ( !ipfilter? ( sys-freebsd/freebsd-pf ) )
"
DEPEND="
	${CDEPEND}
	sys-devel/flex
"
RDEPEND="
	${CDEPEND}
	sys-apps/openrc
	virtual/logger
"

DOCS=( ChangeLog README.rst scripts/sshguard_backendgen.sh )

src_prepare() {
	sed -i -e '/OPTIMIZER_CFLAGS=/d' configure || die
}

src_configure() {
	# Needed for usleep(3), see "nasty" in src/sshguard_logsuck.c
	append-cppflags -D_BSD_SOURCE

	local myconf
	if use kernel_linux; then
		myconf="--with-firewall=iptables"
	elif use kernel_FreeBSD; then
		if use ipfilter; then
			myconf="--with-firewall=ipfw"
		else
			myconf="--with-firewall=pf"
		fi
	fi

	econf ${myconf}
}

src_install() {
	default

	dodoc -r examples/

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
