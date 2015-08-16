# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3 toolchain-funcs

DESCRIPTION="A console-based network monitoring utility"
HOMEPAGE="http://fedorahosted.org/iptraf-ng/"
EGIT_REPO_URI="https://git.fedorahosted.org/git/iptraf-ng.git"

LICENSE="GPL-2 doc? ( FDL-1.1 )"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RESTRICT="test"

RDEPEND="
	>=sys-libs/ncurses-5.7-r7:5=
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
