# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_P="lmon${PV}"
DESCRIPTION="Nigel's performance MONitor for CPU, memory, network, disks, etc"
HOMEPAGE="http://nmon.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}.c"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-16n-musl.patch
)

src_unpack() {
	cp "${DISTDIR}"/${MY_P}.c "${S}"/${PN}.c || die
}

src_configure() {
	local cflags=(
		# Recommended by upstream to be always on
		-DGETUSER
		-DJFS
		-DLARGEMEM
		-DKERNEL_2_6_18

		# Arches
		$(usex amd64 -DX86 '')
		$(usex x86 -DX86 '')
		$(usex arm -DARM '')
		$(usex ppc64 -DPOWER '')
	)

	append-cflags "${cflags[@]}"
	append-libs "$($(tc-getPKG_CONFIG) --libs ncurses) -lm"
}

src_compile() {
	tc-export CC

	emake ${PN} LDLIBS="${LIBS}"
}

src_install() {
	dobin ${PN}
}
