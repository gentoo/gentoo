# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit eutils flag-o-matic

DESCRIPTION="A terminal anywhere"
HOMEPAGE="https://anyterm.org/"
SRC_URI="https://anyterm.org/download/${P}.tbz2"

LICENSE="GPL-2 Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/ssh"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.34.1"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.1.28-respect-LDFLAGS.patch"
	epatch "${FILESDIR}/${P}-gcc-4.4.patch"
	epatch "${FILESDIR}/${P}-boost-1.50.patch"
}

src_compile() {
	# this package uses `ld -r -b binary` and thus resulting executable contains
	# executable stack
	append-ldflags -Wl,-z,noexecstack
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" || die
}

src_install() {
	dosbin anytermd || die
	dodoc CHANGELOG README || die
	doman anytermd.1 || die
	newinitd "${FILESDIR}/anyterm.init.d" anyterm || die
	newconfd "${FILESDIR}/anyterm.conf.d" anyterm || die
}

pkg_postinst() {
	elog "To proceed installation, read following:"
	elog "https://anyterm.org/install.html"
}
