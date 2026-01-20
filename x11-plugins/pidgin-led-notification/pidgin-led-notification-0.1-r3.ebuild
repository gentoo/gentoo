# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN="${PN/pidgin-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pidgin plugin to notify by writing user defined strings to (led control) files"
HOMEPAGE="https://sites.google.com/site/simohmattila/led-notification"
SRC_URI="https://sites.google.com/site/simohmattila/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"

RDEPEND="
	net-im/pidgin[gui]
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-hardware.patch
	"${FILESDIR}"/${P}-includes.patch
)

src_compile() {
	$(tc-getCC) \
		${CFLAGS} -fPIC \
		${CPPFLAGS} \
		${LDFLAGS} \
		$($(tc-getPKG_CONFIG) --cflags gtk+-2.0 pidgin) \
		-shared ${MY_PN}.c -o ${MY_PN}.so \
		$($(tc-getPKG_CONFIG) --libs gtk+-2.0 pidgin) || die
}

src_install() {
	exeinto /usr/$(get_libdir)/pidgin
	doexe ${MY_PN}.so

	einstalldocs
}
