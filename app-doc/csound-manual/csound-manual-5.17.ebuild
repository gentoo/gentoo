# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/csound-manual/csound-manual-5.17.ebuild,v 1.2 2012/09/02 03:33:27 radhermit Exp $

EAPI="4"

MY_P="Csound${PV}"

DESCRIPTION="The Csound reference manual"
HOMEPAGE="http://csounds.com/"
SRC_URI="
	mirror://sourceforge/csound/${MY_P}_manual_pdf.zip
	linguas_fr? ( mirror://sourceforge/csound/${MY_P}_manual-fr_pdf.zip )

	html? (
		mirror://sourceforge/csound/${MY_P}_manual_html.zip
		linguas_fr? ( mirror://sourceforge/csound/${MY_P}_manual-fr_html.zip )
	)"

LICENSE="FDL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="html"

LANGS=" fr"
IUSE+="${LANGS// / linguas_}"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	unpack ${MY_P}_manual_pdf.zip

	if use html ; then
		unpack ${MY_P}_manual_html.zip
		mv html html-en
	fi

	local lang
	for lang in ${LANGS} ; do
		use linguas_${lang} || continue
		unpack ${MY_P}_manual-${lang}_pdf.zip
		if use html ; then
			unpack ${MY_P}_manual-${lang}_html.zip
			mv html html-${lang}
		fi
	done
}

src_install() {
	dodoc *.pdf

	if use html ; then
		dohtml -r html-en/*

		local lang
		for lang in ${LANGS} ; do
			use linguas_${lang} || continue
			docinto html-${lang}
			dohtml -r html-${lang}/*
		done
	fi
}
