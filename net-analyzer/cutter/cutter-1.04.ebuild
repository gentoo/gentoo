# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="TCP/IP Connection cutting on Linux Firewalls and Routers"
HOMEPAGE="http://www.digitage.co.uk/digitage/software/linux-security/cutter"
SRC_URI="http://www.digitage.co.uk/digitage/files/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.03-debian.patch
)

src_prepare() {
	default

	# implicit rules are better ;x
	rm -f Makefile || die
}

src_compile() {
	emake cutter CC="$(tc-getCC)"
}

src_install() {
	dosbin cutter
	dodoc README
	doman debian/cutter.8
}
