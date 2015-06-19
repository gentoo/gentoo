# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/bongo/bongo-20110621.ebuild,v 1.3 2014/06/07 10:36:05 ulm Exp $

EAPI=5

inherit elisp eutils

DESCRIPTION="Buffer-oriented media player for Emacs"
HOMEPAGE="http://www.brockman.se/software/bongo/"
# Darcs snapshot of http://www.brockman.se/software/bongo/
# MPlayer support from http://www.emacswiki.org/emacs/bongo-mplayer.el
SRC_URI="mirror://gentoo/${P}.tar.xz
	mplayer? ( mirror://gentoo/${PN}-mplayer-20070204.tar.bz2 )"

LICENSE="GPL-2+ FDL-1.2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mplayer"

# NOTE: Bongo can use almost anything for playing media files, therefore
# the dependency possibilities are so broad that we refrain from including
# any media players explicitly in DEPEND/RDEPEND.

RDEPEND="app-emacs/volume"
DEPEND="${RDEPEND}
	sys-apps/texinfo"

S="${WORKDIR}/${PN}"
DOCS="AUTHORS HISTORY NEWS README.rdoc"
ELISP_PATCHES="${PN}-20070619-fix-require.patch
	${P}-texinfo-5.patch"
ELISP_REMOVE="bongo-emacs21.el"	# Don't bother with Emacs 21
ELISP_TEXINFO="${PN}.texinfo"
SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install
	insinto "${SITEETC}/${PN}"
	doins etc/*.pbm etc/*.png
}
