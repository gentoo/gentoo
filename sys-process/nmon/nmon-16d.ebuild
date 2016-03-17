# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs

MY_P="lmon${PV}"

DESCRIPTION="Nigel's performance MONitor for CPU, memory, network, disks, etc..."
HOMEPAGE="http://nmon.sourceforge.net/"
LICENSE="GPL-3"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.c"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~ppc64"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}"

src_unpack() {
	cp -v -f "${DISTDIR}"/${MY_P}.c "${S}"/${PN}.c || die
}

src_configure() {
	local cflags=(
		## recommended by upstream to be always on
		-DGETUSER
		-DJFS
		-DLARGEMEM
		-DKERNEL_2_6_18

		## archs
		$(usex amd64 -DX86 '')
		$(usex x86 -DX86 '')
		$(usex arm -DARM '')
		$(usex ppc64 -DPOWER '')
	)
	append-cflags "${cflags[@]}"
	export LDLIBS="$( $(tc-getPKG_CONFIG) --libs ncurses ) -lm"
}

src_compile() {
	emake ${PN}
}

src_install() {
	dobin ${PN}
}
