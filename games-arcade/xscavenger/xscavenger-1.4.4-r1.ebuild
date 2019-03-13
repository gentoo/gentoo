# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop epatch toolchain-funcs

DESCRIPTION="Lode-Runner-like arcade game"
HOMEPAGE="http://www.xdr.com/dash/scavenger.html"
SRC_URI="http://www.xdr.com/dash/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-misc/imake
"

S="${WORKDIR}/${P}/src"

src_prepare() {
	default
	epatch "${FILESDIR}/${PV}-gentoo.patch"
	sed -i \
		-e "s:GENTOO_DATADIR:/usr/share:" \
		-e "s:GENTOO_BINDIR:/usr/bin:" \
		Imakefile \
		|| die
}

src_configure() {
	xmkmf || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ../{CREDITS,DOC,README,TODO,changelog}
	make_desktop_entry scavenger "XScavenger"
}
