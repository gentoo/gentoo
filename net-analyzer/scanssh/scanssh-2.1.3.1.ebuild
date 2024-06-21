# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="network scanner that gathers info on SSH protocols and versions"
HOMEPAGE="https://github.com/ofalk/scanssh/"
SRC_URI="https://github.com/ofalk/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"

DEPEND="
	dev-libs/libdnet
	dev-libs/libevent:=
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0-fix-warnings.diff
	"${FILESDIR}"/${PN}-2.1.3-libdir.diff
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		DNETINC='' \
		DNETLIB=-ldnet \
		EVENTINC='' \
		EVENTLIB=-levent \
		PCAPINC='' \
		PCAPLIB=-lpcap
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dobin scanssh
	doman scanssh.1
}
