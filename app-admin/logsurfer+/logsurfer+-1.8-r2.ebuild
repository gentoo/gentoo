# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit toolchain-funcs user

MY_P="logsurfer-${PV}"
DESCRIPTION="Real Time Log Monitoring and Alerting"
HOMEPAGE="http://www.crypt.gen.nz/logsurfer/"
SRC_URI="http://kerryt.orcon.net.nz/${MY_P}.tar.gz
	http://www.crypt.gen.nz/logsurfer/${MY_P}.tar.gz"

LICENSE="freedist GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="bindist" #444330

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf --with-etcdir=/etc
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin src/logsurfer
	doman man/logsurfer.1 man/logsurfer.conf.4

	newinitd "${FILESDIR}"/logsurfer-1.8.initd logsurfer
	newconfd "${FILESDIR}"/logsurfer.confd logsurfer
	dodoc ChangeLog README TODO
}

pkg_postinst() {
	enewuser logsurfer -1 -1 -1 daemon
}
