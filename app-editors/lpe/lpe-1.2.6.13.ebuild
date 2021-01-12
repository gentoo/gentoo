# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="a lightweight programmers editor"
HOMEPAGE="https://packages.qa.debian.org/l/lpe.html"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${PV}-0.1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~x86-linux"
IUSE="nls"

RDEPEND="
	sys-libs/ncurses:0=
	sys-libs/slang"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-make-382.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default

	# You should add PKG_CHECK_MODULES(NCURSES, ncurses) to configure.in and
	# replace -lncurses in src/Makefile.am with $(NCURSES_LIBS)
	# That is, if you need eautoreconf
	sed -i \
		-e "s:-lncurses:$($(tc-getPKG_CONFIG) --libs-only-l ncurses):" \
		src/Makefile.in || die
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake \
		libdir="${ED}/usr/$(get_libdir)" \
		prefix="${ED}/usr" \
		datadir="${ED}/usr/share" \
		mandir="${ED}/usr/share/man" \
		infodir="${ED}/usr/share/info" \
		docdir="${ED}/usr/share/doc/${PF}" \
		exdir="${ED}/usr/share/doc/${PF}/examples" \
		install

	find "${ED}" -name '*.la' -delete || die
}
