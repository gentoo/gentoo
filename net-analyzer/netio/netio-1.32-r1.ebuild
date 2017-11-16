# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs

DESCRIPTION="measures net throughput with NetBIOS and TCP/IP protocols"
HOMEPAGE="https://web.ars.de/netio/"
SRC_URI="http://web.ars.de/wp-content/uploads/2017/04/${PN}${PV/./}.zip"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
RESTRICT="mirror" # bug #391789 comment #1

DEPEND="
	app-arch/unzip
	>=sys-apps/sed-4
"

S="${WORKDIR}"
PATCHES=(
	"${FILESDIR}"/${PN}-1.26-linux-include.patch
)

src_prepare() {
	edos2unix *.c *.h *.doc

	default

	sed -i \
		-e "s|LFLAGS=\"\"|LFLAGS?=\"${LDFLAGS}\"|g" \
		-e 's|\(CC\)=|\1?=|g' \
		-e 's|\(CFLAGS\)=|\1+=|g' \
		Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		linux
}

src_install() {
	dobin netio
	dodoc netio.doc
}
