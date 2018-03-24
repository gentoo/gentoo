# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="uu, xx, base64, binhex decoder"
HOMEPAGE="http://www.fpx.de/fp/Software/UUDeview/"
SRC_URI="http://www.fpx.de/fp/Software/UUDeview/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="tk"

RDEPEND="tk? ( dev-lang/tk:0 )"
DEPEND="${RDEPEND}"

DOCS=( HISTORY INSTALL README )

PATCHES=(
	"${FILESDIR}/${PN}-0.5.20-bugfixes.patch"
	"${FILESDIR}/${PN}-0.5.20-CVE-2004-2265.patch"
	"${FILESDIR}/${PN}-0.5.20-CVE-2008-2266.patch"
	"${FILESDIR}/${PN}-0.5.20-man.patch"
	"${FILESDIR}/${PN}-0.5.20-rename.patch"
	"${FILESDIR}/${PN}-0.5.20-makefile.patch"
)

src_prepare() {
	eapply "${PATCHES[@]}"

	mv configure.in configure.ac || die

	eapply_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable tk tcl) \
		$(use_enable tk)
}
