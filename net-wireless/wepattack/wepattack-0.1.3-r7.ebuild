# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="WepAttack-${PV}"
DESCRIPTION="WLAN tool for breaking 802.11 WEP keys"
HOMEPAGE="https://wepattack.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/wepattack/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="john"

DEPEND="
	dev-libs/openssl:=
	net-libs/libpcap
	sys-libs/zlib
"
RDEPEND="
	${DEPEND}
	john? (
		|| (
			app-crypt/johntheripper
			app-crypt/johntheripper-jumbo
		)
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-filter-mac-address.patch
	"${FILESDIR}"/${P}-missed-string.h-warnings-fix.patch
	"${FILESDIR}"/${P}-modern-c.patch
	"${FILESDIR}"/${P}-seds.patch
	"${FILESDIR}"/${P}-signals.patch
)

src_compile() {
	tc-export CC
	emake -C src
}

src_test() {
	src/wepattack || die "Program can't start"
}

src_install() {
	dodoc README
	dobin src/wepattack

	if use john; then
		dosbin run/wepattack_{inc,word}
		insinto /etc
		doins "${FILESDIR}"/wepattack.conf
	fi
}
