# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
	SRC_URI="http://www.thc.org/releases/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="net-libs/libpcap
	net-libs/libnetfilter_queue
	ssl? ( dev-libs/openssl:* )"
RDEPEND="${DEPEND}"

src_unpack() {
	if [[ ${PV} != *9999 ]]; then
		default_src_unpack
	else
		git-r3_src_unpack
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.0-Makefile.patch
	sed -i \
		-e '/^CFLAGS=/s,CFLAGS=,CFLAGS?=,' \
		Makefile
	if ! use ssl ; then
		sed -e '/^HAVE_SSL/s:^:#:' \
			-i Makefile
	fi
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" STRIP="true" install
	dodoc CHANGES HOWTO-INJECT README
}
