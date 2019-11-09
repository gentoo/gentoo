# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="A package for translating words in TeX"
HOMEPAGE="https://bitbucket.org/rivanvx/beamer/src"
SRC_URI="mirror://sourceforge/latex-beamer/${P}.tar.gz"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
IUSE="doc"

TEXMF="/usr/share/texmf-site"

src_install() {
	insinto ${TEXMF}/tex/latex/translator
	doins base/*
	doins -r dicts/*
	dodoc ChangeLog README

	use doc && dodoc -r doc/*
}
