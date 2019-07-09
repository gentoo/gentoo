# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils toolchain-funcs versionator

MY_PV=$(delete_version_separator _)

DESCRIPTION="FTJam is a 100% compatible, enhanced implementation of the make alternative Jam"
HOMEPAGE="http://freetype.sourceforge.net/jam/index.html"
SRC_URI="http://david.freetype.org/jam/ftjam-${MY_PV}.tar.bz2"

LICENSE="perforce GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="!dev-util/jam
	sys-devel/bison"
RDEPEND="!dev-util/jam"

S=${WORKDIR}/${PN}-${MY_PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-2.5.3-nostrip.patch
	epatch "${FILESDIR}"/${PN}-2.5.3-i-hate-yacc.patch
	epatch "${FILESDIR}"/${PN}-2.5.3-false-flags.patch
#	epatch "${FILESDIR}"/${PN}-2.5.3-debug-commandline.patch  # development only
}

src_compile() {
	tc-export CC
	econf
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README README.ORG CHANGES INSTALL RELNOTES
	dohtml Jam.html Jambase.html Jamfile.html
}
