# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/sercd/sercd-3.0.0-r1.ebuild,v 1.1 2014/12/04 07:14:50 pinkbyte Exp $

EAPI=5

inherit eutils

DESCRIPTION="RFC2217-compliant serial port redirector"
HOMEPAGE="http://sourceforge.net/projects/sercd"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="xinetd"

RDEPEND="xinetd? ( virtual/inetd )"

DOCS=( AUTHORS README )

src_prepare() {
	epatch_user
}

src_install () {
	default

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/${PN}.xinetd" "${PN}"
	fi
}
