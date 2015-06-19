# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/convertlit/convertlit-1.8-r1.ebuild,v 1.14 2013/08/24 13:09:21 maekke Exp $

inherit eutils toolchain-funcs

MY_P="clit${PV//./}"

DESCRIPTION="CLit converts MS ebook .lit files to .opf (xml+html+png+jpg)"
HOMEPAGE="http://www.convertlit.com/"
SRC_URI="http://www.convertlit.com/${MY_P}src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ppc64 x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND=">=dev-libs/libtommath-0.36-r1"

DEPEND="${RDEPEND}
	app-arch/unzip"

RDEPEND="${RDEPEND}
	!app-text/open_c-lit"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-respectflags.patch"
}

src_compile() {
	tc-export CC

	cd "${S}"/lib
	emake || die "make lib failed"
	cd "${S}"/${MY_P}
	emake || die "make ${MY_P} failed"
}

src_install() {
	dobin ${MY_P}/clit || die
	dodoc README
}
