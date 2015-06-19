# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/cntlm/cntlm-0.93_beta5-r1.ebuild,v 1.1 2014/07/01 19:21:44 pacho Exp $

EAPI=5
inherit eutils systemd toolchain-funcs user

DESCRIPTION="Cntlm is an NTLM/NTLMv2 authenticating HTTP proxy"
HOMEPAGE="http://cntlm.sourceforge.net/"
SRC_URI="http://ftp.awk.cz/pub/${P//_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${P//_}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-buildsystem.patch # 334647
}

src_configure() {
	tc-export CC

	econf

	# Replace default config file path in Makefile
	sed -i -e 's~SYSCONFDIR=/usr/local/etc~SYSCONFDIR=/etc~' \
				"${S}"/Makefile || die "sed failed"
}

src_compile() {
	emake V=1
}

src_install() {
	dobin cntlm
	dodoc COPYRIGHT README VERSION doc/cntlm.conf
	doman doc/cntlm.1
	newinitd "${FILESDIR}"/cntlm.initd cntlm
	newconfd "${FILESDIR}"/cntlm.confd cntlm
	systemd_dounit "${FILESDIR}"/cntlm.service
	insinto /etc
	insopts -m0600
	doins doc/cntlm.conf
}

pkg_postinst() {
	enewgroup cntlm
	enewuser cntlm -1 -1 -1 cntlm
}
