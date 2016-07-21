# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils flag-o-matic

DESCRIPTION="Ben Fennema's tools for packet writing and the UDF filesystem"
HOMEPAGE="https://github.com/pali/udftools/ https://sourceforge.net/projects/linux-udf/"
SRC_URI="https://github.com/pali/udftools/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE=""

RDEPEND="sys-libs/readline:0="
DEPEND="${RDEPEND}"

src_install() {
	default
	newinitd "${FILESDIR}"/pktcdvd.init pktcdvd
	dosym mkudffs.8 /usr/share/man/man8/mkfs.udf.8
}
