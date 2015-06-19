# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/lpe/lpe-1.2.6.13.ebuild,v 1.13 2013/03/07 15:24:26 ssuominen Exp $

EAPI=5
inherit eutils multilib toolchain-funcs

DESCRIPTION="a lightweight programmers editor"
HOMEPAGE="http://packages.qa.debian.org/l/lpe.html"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${PV}-0.1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~x86-linux"
IUSE="nls"

RDEPEND=">=sys-libs/slang-2.2.4
	>=sys-libs/ncurses-5.7-r7"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-make-382.patch

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

	prune_libtool_files --all
}
