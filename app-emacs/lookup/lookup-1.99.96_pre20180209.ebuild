# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp

COMMIT="c4f4986aac6c339e03b9e56a5dfc7c8f5c0bb5e0"
DESCRIPTION="An interface to search CD-ROM books and network dictionaries"
HOMEPAGE="https://lookup2.github.io/lookup2/"
SRC_URI="https://github.com/lookup2/lookup2/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="sys-apps/texinfo"

S="${WORKDIR}/lookup2-${COMMIT}"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --with-lispdir="${EPREFIX}${SITELISP}"
}

src_compile() {
	default
}

src_install() {
	emake DESTDIR="${D}" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc AUTHORS NEWS README.md
}
