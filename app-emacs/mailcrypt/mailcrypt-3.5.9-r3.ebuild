# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

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
ELISP_TEXINFO="mailcrypt.texi"
DOCS="ANNOUNCE ChangeLog* INSTALL NEWS ONEWS README* WARNINGS"
DOC_CONTENTS="See the INSTALL file in /usr/share/doc/${PF} for how to
	customize mailcrypt."
