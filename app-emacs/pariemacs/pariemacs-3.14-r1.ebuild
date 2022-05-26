# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="sci-mathematics/pari emacs mode"
HOMEPAGE="http://iml.univ-mrs.fr/~ramare/ServeurPerso/GP-PARI/"
SRC_URI="http://iml.univ-mrs.fr/~ramare/ServeurPerso/GP-PARI/latest-pari-distrib/${P}.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sci-mathematics/pari"
DEPEND="${RDEPEND}"

SITEFILE="64${PN}-gentoo.el"
DOCS="README CHANGES"
PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

src_prepare() {
	default
	if [ -f /usr/share/pari/pari.cfg ]; then
		cp /usr/share/pari/pari.cfg . || die
	elif [ -f /usr/share/pari/pari.cfg.bz2 ]; then
		cp /usr/share/pari/pari.cfg.bz2 . || die
		bunzip2 pari.cfg.bz2 || die
	else
		die "pari.cfg not found"
	fi
}

src_compile() {
	emake pari-conf.el
	emake elc
}
