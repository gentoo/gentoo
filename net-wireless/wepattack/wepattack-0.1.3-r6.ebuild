# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="WepAttack-${PV}"
DESCRIPTION="WLAN tool for breaking 802.11 WEP keys"
HOMEPAGE="http://wepattack.sourceforge.net/"
SRC_URI="mirror://sourceforge/wepattack/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
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
)

src_prepare() {
	default

	chmod +x src/wlan || die
	sed -i \
		-e "/^CFLAGS=/s:=:=${CFLAGS} :" \
		-e 's:-fno-for-scope::g' \
		-e "/^CC=/s:gcc:$(tc-getCC):" \
		-e "/^LD=/s:gcc:$(tc-getCC):" \
		-e 's:log.o\\:log.o \\:' \
		src/Makefile || die
	sed -i \
		-e "s/wordfile:/-wordlist=/" \
		run/wepattack_word || die
}

src_compile() {
	emake -C src
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
