# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Easy creation of form letters written in LaTeX"
HOMEPAGE="http://nasauber.de/opensource/serienbrief/"
SRC_URI="http://nasauber.de/opensource/serienbrief/${P}.tar.gz"

LICENSE="GPL-2" # GPLv2 only
SLOT="0"
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
	# install if LINGUAS is unset, or if it contains the language code
	if [[ -z ${LINGUAS+set} ]] || has de ${LINGUAS}; then
		domo po/de.mo
	fi
	dodoc ChangeLog doc/example/*
}
