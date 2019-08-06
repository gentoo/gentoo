# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="network scanner that gathers info on SSH protocols and versions"
HOMEPAGE="https://monkey.org/~provos/scanssh/"
SRC_URI="https://monkey.org/~provos/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

DEPEND="
	dev-libs/libdnet
	dev-libs/libevent:=
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.0-fix-warnings.diff
)

src_prepare() {
	default
	touch configure
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dobin scanssh
	doman scanssh.1
}
