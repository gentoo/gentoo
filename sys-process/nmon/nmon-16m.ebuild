# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_P="lmon${PV}"

DESCRIPTION="Nigel's performance MONitor for CPU, memory, network, disks, etc..."
HOMEPAGE="http://nmon.sourceforge.net/"
LICENSE="GPL-3"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.c"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/${MY_P}.c "${S}"/${PN}.c || die
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
	append-libs "$($(tc-getPKG_CONFIG) --libs ncurses) -lm"
}

src_compile() {
	emake ${PN} LDLIBS="${LIBS}"
}

src_install() {
	dobin ${PN}
}
