# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcpflow/tcpflow-1.3.0.ebuild,v 1.4 2014/06/12 20:18:21 grobian Exp $

EAPI="4"

DESCRIPTION="A tool for monitoring, capturing and storing TCP connections flows"
HOMEPAGE="https://github.com/simsong/tcpflow"
SRC_URI="mirror://github/simsong/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
SLOT="0"
IUSE="test"

RDEPEND="net-libs/libpcap
	sys-libs/zlib"
DEPEND="${RDEPEND}
	test? ( sys-apps/coreutils )"

src_prepare() {
	sed -i -e 's:`md5 -q \(.*\)`:`md5sum \1 | cut -f1 -d" "`:' tests/*.sh || die
}
