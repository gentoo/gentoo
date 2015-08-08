# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils
DESCRIPTION="Courierpassd is a utility for changing a user's password from across a network"
HOMEPAGE="http://www.arda.homeunix.net/"
SRC_URI="http://www.arda.homeunix.net/store/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="xinetd"

DEPEND="net-libs/courier-authlib
		xinetd? ( sys-apps/xinetd )"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use xinetd; then
		insinto /etc/xinetd.d
		doins "${FILESDIR}/courierpassd" || die "doins failed"
	fi

	dodoc README AUTHORS ChangeLog NEWS || die "dodoc failed"
}
