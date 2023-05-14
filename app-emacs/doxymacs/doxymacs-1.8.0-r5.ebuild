# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Doxygen editing minor mode"
HOMEPAGE="http://doxymacs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-libs/libxml2-2.6.13"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-gcc7.patch
)

DOCS=( AUTHORS ChangeLog NEWS README TODO )
SITEFILE="50${PN}-gentoo.el"

src_configure() {
	econf --with-lispdir="${SITELISP}/${PN}"
}

src_compile() {
	default
}

src_install() {
	emake DESTDIR="${D}" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	einstalldocs
}
