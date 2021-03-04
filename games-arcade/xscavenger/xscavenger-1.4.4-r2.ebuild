# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Lode-Runner-like arcade game"
HOMEPAGE="http://www.xdr.com/dash/scavenger.html"
SRC_URI="http://www.xdr.com/dash/${P}.tgz"
S="${WORKDIR}/${P}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="x11-misc/imake"
RDEPEND="x11-libs/libXext"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-gentoo.patch"
)

src_prepare() {
	default

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
