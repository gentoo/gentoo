# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

IUSE=""
DESCRIPTION="daemon providing access to the kernel sysrq functions via network"
HOMEPAGE="http://julien.danjou.info/projects/sysrqd"
#SRC_URI="http://julien.danjou.info/${PN}/${P}.tar.gz"
SRC_URI="http://dev.gentoo.org/~wschlich/src/${CATEGORY}/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-config.patch"
}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o sysrqd sysrqd.c
}

src_install() {
	dosbin sysrqd
	newinitd "${FILESDIR}/sysrqd.init" sysrqd

	local bindip='127.0.0.1' secret
	declare -i secret
	let secret=${RANDOM}*${RANDOM}*${RANDOM}*${RANDOM}
	echo ${bindip} > sysrqd.bind
	echo ${secret} > sysrqd.secret

	diropts -m 0700 -o root -g root
	dodir /etc/sysrqd
	insinto /etc/sysrqd
	insopts -m 0600 -o root -g root
	doins sysrqd.bind
	doins sysrqd.secret

	dodoc README ChangeLog
}

pkg_postinst() {
	elog
	elog "Be sure to change the initial secret in /etc/sysrqd/sysrqd.secret !"
	elog "As a security precaution, sysrqd is configured to only listen on"
	elog "127.0.0.1 by default. Change the content of /etc/sysrqd/sysrqd.bind"
	elog "to an IPv4 address you want it to listen on or remove the file"
	elog "to make it listen on any IP address (0.0.0.0)."
	elog
}
