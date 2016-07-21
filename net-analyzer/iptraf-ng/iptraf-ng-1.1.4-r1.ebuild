# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="A console-based network monitoring utility"
HOMEPAGE="http://fedorahosted.org/iptraf-ng/"
SRC_URI="http://fedorahosted.org/releases/${PN:0:1}/${PN:1:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2 doc? ( FDL-1.1 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="doc"

RESTRICT="test"

RDEPEND="
	>=sys-libs/ncurses-5.7-r7:0=
"
DEPEND="
	${RDEPEND}
	virtual/os-headers
	!net-analyzer/iptraf
"

src_prepare() {
	sed -i \
		-e '/^CC =/d' \
		-e '/^CFLAGS/s:= -g -O2:+= :' \
		-e '/^LDFLAGS =/d' \
		-e 's|$(QUIET_[[:alpha:]]*)||g' \
		Makefile || die
	sed -i \
		-e 's|IPTRAF|&-NG|g' \
		-e 's|IPTraf|&-NG|g' \
		-e 's|iptraf|&-ng|g' \
		-e 's|rvnamed|&-ng|g' \
		-e 's|RVNAMED|&-NG|g' \
		src/*.8 || die

	epatch "${FILESDIR}"/${P}-tcplog_flowrate_msg.patch
}

# configure does not do very much we do not already control
src_configure() { :; }

src_compile() {
	tc-export CC
	CFLAGS+=' -DLOCKDIR=\"/run/lock/iptraf-ng\"'
	default
}

src_install() {
	dosbin {iptraf,rvnamed}-ng

	doman src/*.8
	dodoc AUTHORS CHANGES FAQ README* RELEASE-NOTES
	use doc && dohtml -a gif,html,png -r Documentation/*

	keepdir /var/{lib,log}/iptraf-ng #376157
}
