# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Complete tool set to attack the inherent protocol weaknesses of IPV6 and ICMP6"
HOMEPAGE="https://github.com/vanhauser-thc/thc-ipv6"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/vanhauser-thc/thc-ipv6.git"
	EGIT_BRANCH=master
	inherit git-r3
else
	HASH="7f3589fab681966d0b0c76ab9709ff9cafbd009a"
	S="${WORKDIR}/${PN}-${HASH}"
	SRC_URI="https://github.com/vanhauser-thc/thc-ipv6/archive/${HASH}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="AGPL-3 openssl"
SLOT="0"
IUSE="ssl"

DEPEND="
	net-libs/libnetfilter_queue
	net-libs/libpcap
	ssl? ( dev-libs/openssl:0= )
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e '/^CFLAGS+=-g/s,CFLAGS+=,CFLAGS?=,' \
		-i Makefile || die

	if ! use ssl; then
		sed -e '/^HAVE_SSL/s:^:#:' \
			-i Makefile || die
	fi

	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" STRIP="true" install
	dodoc CHANGES HOWTO-INJECT README.md
}
