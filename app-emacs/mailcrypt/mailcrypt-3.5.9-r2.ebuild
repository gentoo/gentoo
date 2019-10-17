# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 elisp autotools

DESCRIPTION="Provides a simple interface to public key cryptography with OpenPGP"
HOMEPAGE="http://mailcrypt.sourceforge.net/"
SRC_URI="mirror://sourceforge/mailcrypt/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
RESTRICT="test"

RDEPEND="app-crypt/gnupg"

ELISP_PATCHES="${P}-backquotes.patch"
ELISP_REMOVE="FSF-timer.el"		# remove bundled timer.el
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare
	eautoreconf
}

src_configure() {
	export EMACS
	econf
}

src_install() {
	emake \
		lispdir="${D}${SITELISP}/${PN}" \
		infodir="${D}/usr/share/info" \
		install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc ANNOUNCE ChangeLog* INSTALL LCD-entry NEWS ONEWS README*

	DOC_CONTENTS="See the INSTALL file in /usr/share/doc/${PF} for how
		to customize mailcrypt."
	readme.gentoo_create_doc
}
