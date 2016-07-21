# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Proxies NDP messages between interfaces"
HOMEPAGE="http://priv.nu/projects/ndppd/"
SRC_URI="http://priv.nu/projects/ndppd/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install()
{
	emake PREFIX=/usr DESTDIR="${D}" install
	insinto /etc
	newins ndppd.conf-dist ndppd.conf
	newinitd "${FILESDIR}"/ndppd.initd ndppd
}
