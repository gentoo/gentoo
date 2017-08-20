# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Open Source Deep Packet Inspection Software Toolkit"
HOMEPAGE="http://www.ntop.org/"
SRC_URI="https://github.com/ntop/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/json-c
	net-libs/libpcap"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}
