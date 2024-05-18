# Copyright 1999-2024 Gentoo Authors
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
	SRC_URI="https://github.com/vanhauser-thc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
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
	dodoc CHANGES HOWTO-INJECT README
}
