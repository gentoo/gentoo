# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/serienbrief/serienbrief-0.2.4.ebuild,v 1.1 2013/05/17 15:44:14 aballier Exp $

EAPI=4

DESCRIPTION="Easy creation of form letters written in LaTeX"
HOMEPAGE="http://nasauber.de/opensource/serienbrief/"
SRC_URI="http://nasauber.de/opensource/serienbrief/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
LINS=("de")

for ((i=0; i<${#LINS[@]}; i++)) do
	IUSE="${IUSE} linguas_${LINS[$i]}"
done

KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=">=dev-lang/perl-5.8.6
	virtual/perl-Getopt-Long
	>=virtual/perl-Term-ANSIColor-1.08
	>=dev-perl/libintl-perl-1.16
	virtual/latex-base"

src_install() {
	dobin bin/serienbrief
	doman doc/serienbrief.1
	if use linguas_de; then
		mv po/de.mo serienbrief.mo
		insinto /usr/share/locale/de/LC_MESSAGES
		doins serienbrief.mo
	fi
	dodoc ChangeLog doc/example/*
}
