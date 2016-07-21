# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

MY_PN="LinuxSPA"
DESCRIPTION="Linux Serial Protocol Analyser"
HOMEPAGE="http://sourceforge.net/projects/serialsniffer/"
SRC_URI="mirror://sourceforge/serialsniffer/${MY_PN}-${PV}.tgz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-compile-fix.patch
	sed -i Makefile \
		-e 's| -o | $(LDFLAGS)&|g' \
		|| die "sed Makefile"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -Wall" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin LinuxSPA std232
	dodoc ASCII_Filter.txt BCircuit.txt LinuxSPA.png READING_Materials.txt \
		README TODO connector-1a.ps connector-2a.ps cooked.file raw.file
}
