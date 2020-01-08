# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="PostScript Utilities"
HOMEPAGE="http://web.archive.org/web/20110722005140/http://www.tardis.ed.ac.uk/~ajcd/psutils/"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}.dfsg.orig.tar.gz"

LICENSE="psutils"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-lang/perl"

S="${WORKDIR}/${P}.orig"

src_prepare() {
	eapply "${FILESDIR}/${P}-ldflags.patch"
	eapply "${FILESDIR}/${P}-no-fixmacps.patch"
	sed \
		-e "s:/usr/local:\$(DESTDIR)${EPREFIX}/usr:" \
		"${S}/Makefile.unix" > "${S}/Makefile"
	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install () {
	dodir /usr/{bin,share/man}
	emake DESTDIR="${D}" install
	dodoc README
}
