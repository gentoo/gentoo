# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Courierpassd is a utility for changing a user's password from across a network"
HOMEPAGE="http://www.arda.homeunix.net/"
SRC_URI="http://www.arda.homeunix.net/?ddownload=375 -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xinetd"

DEPEND="net-libs/courier-authlib
	xinetd? ( sys-apps/xinetd )"
RDEPEND="${DEPEND}"

src_install() {
	default

	if use xinetd; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}"/${PN}.xinetd ${PN}
	fi
}
