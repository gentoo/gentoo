# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
[[ ${PV} == *9999 ]] && SCM="git-r3"
EGIT_REPO_URI="https://github.com/vanhauser-thc/thc-ipv6.git"
EGIT_BRANCH=master

inherit eutils toolchain-funcs ${SCM}

DESCRIPTION="complete tool set to attack the inherent protocol weaknesses of IPV6 and ICMP6"
HOMEPAGE="https://www.thc.org/thc-ipv6/"
LICENSE="AGPL-3 openssl"
SLOT="0"
IUSE="ssl"

if [[ ${PV} != *9999 ]]; then
	SRC_URI="https://github.com/vanhauser-thc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="net-libs/libpcap
	net-libs/libnetfilter_queue
	ssl? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-3.2-stdint.patch" )

src_unpack() {
	if [[ ${PV} != *9999 ]]; then
		default_src_unpack
	else
		git-r3_src_unpack
	fi
}

src_prepare() {
	sed -e '/^CFLAGS=/s,CFLAGS=,CFLAGS?=,' \
		-i Makefile || die
	if ! use ssl ; then
		sed -e '/^HAVE_SSL/s:^:#:' \
			-i Makefile
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
