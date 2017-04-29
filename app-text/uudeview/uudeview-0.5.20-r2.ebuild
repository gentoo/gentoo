# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils autotools

DESCRIPTION="uu, xx, base64, binhex decoder"
HOMEPAGE="http://www.fpx.de/fp/Software/UUDeview/"
SRC_URI="http://www.fpx.de/fp/Software/UUDeview/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="tk"

RDEPEND="tk? ( dev-lang/tk:0 )"
DEPEND="${RDEPEND}"

DOCS=( HISTORY INSTALL README )

PATCHES=(
	"${FILESDIR}/${P}-bugfixes.patch"
	"${FILESDIR}/${P}-CVE-2004-2265.patch"
	"${FILESDIR}/${P}-CVE-2008-2266.patch"
	"${FILESDIR}/${P}-man.patch"
	"${FILESDIR}/${P}-rename.patch"
	"${FILESDIR}/${P}-makefile.patch"
)

src_prepare() {
	epatch "${PATCHES[@]}"

	mv configure.in configure.ac || die

	epatch_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable tk tcl) \
		$(use_enable tk)
}
