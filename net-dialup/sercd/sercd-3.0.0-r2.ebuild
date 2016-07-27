# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="RFC2217-compliant serial port redirector"
HOMEPAGE="https://sourceforge.net/projects/sercd"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="xinetd"

RDEPEND="xinetd? ( virtual/inetd )"

DOCS=( AUTHORS README )

src_prepare() {
	eapply_user
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
