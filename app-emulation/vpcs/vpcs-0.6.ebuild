# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Simulate up to 9 PCs in place of VMware boxes in a Dynamips network"
HOMEPAGE="http://vpcs.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-src.tbz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${S}/src/"

src_prepare() {
	# move Makefile in place
	cp Makefile.linux Makefile

	# replace hardcoded CFLAGS with user set CFLAGS
	# append -fno-strict-aliasing to CFLAGS to suppress QA issues from upstream
	# add user $LDFLAGS in the front and remove -s that strips binary
	sed -e "s/-D\$(CPUTYPE)/${CFLAGS} -fno-strict-aliasing/" \
		-e "s/^LDFLAGS=/LDFLAGS=${LDFLAGS} /" \
		-e "s/-s //" \
		-i Makefile || die
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	#put binary in /usr/bin
	dobin vpcs

	doman ../man/vpcs.1
}
