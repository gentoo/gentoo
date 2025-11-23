# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTE: netwib, netwox and netwag go together, bump all or bump none

EAPI=8

inherit dot-a toolchain-funcs

DESCRIPTION="Library of Ethernet, IP, UDP, TCP, ICMP, ARP and RARP protocols"
HOMEPAGE="
	https://ntwib.sourceforge.net/
"
SRC_URI="
	https://downloads.sourceforge.net/ntwib/${P}-src.tgz
	doc? ( https://downloads.sourceforge.net/ntwib/${P}-doc_html.tgz )"
S="${WORKDIR}/${P}-src/src"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc x86"
IUSE="doc"

DEPEND="
	net-libs/libnet:1.1
	net-libs/libpcap"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-C99-decls.patch
	"${FILESDIR}"/${P}-config.patch
	"${FILESDIR}"/${P}-sched_yield.patch
)

src_configure() {
	tc-export AR CC RANLIB
	sed -e "s:/lib:/$(get_libdir):" \
		-i config.dat || die
	# the only package output is static libs
	lto-guarantee-fat

	sh genemake || die
}

src_install() {
	default
	strip-lto-bytecode

	dodoc \
		../README.TXT \
		../doc/{changelog.txt,credits.txt,integration.txt} \
		../doc/{problemreport.txt,problemusageunix.txt,todo.txt}

	if use doc; then
		docinto html
		dodoc -r "${WORKDIR}"/${P}-doc_html/{index.html,${PN}}
	fi
}
