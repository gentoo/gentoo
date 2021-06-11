# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=Csound${PV}.0

DESCRIPTION="The Csound reference manual"
HOMEPAGE="http://csounds.com/"
SRC_URI="
	https://github.com/csound/csound/releases/download/${PV}.0/${MY_P}_manual_pdf.zip
	l10n_fr? ( https://github.com/csound/csound/releases/download/${PV}.0/${MY_P}_manual-fr_pdf.zip )

	html? (
		https://github.com/csound/csound/releases/download/${PV}.0/${MY_P}_manual_html.zip
		l10n_fr? ( https://github.com/csound/csound/releases/download/${PV}.0/${MY_P}_manual-fr_html.zip )
	)"

LICENSE="FDL-1.2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="html"

LANGS=" fr"
IUSE+="${LANGS// / l10n_}"

BDEPEND="
	app-arch/unzip
	media-libs/libpng:0
"

S=${WORKDIR}

src_unpack() {
	unpack ${MY_P}_manual_pdf.zip

	if use html ; then
		unpack ${MY_P}_manual_html.zip
		mv html html-en
	fi

	local lang
	for lang in ${LANGS} ; do
		use l10n_${lang} || continue
		unpack ${MY_P}_manual-${lang}_pdf.zip
		if use html ; then
			unpack ${MY_P}_manual-${lang}_html.zip
			mv html html-${lang}
		fi
	done
}

src_prepare() {
	default

	# Fix broken png file, bug 737130
	if use html; then
		local png=html-en/images/delayk.png
		pngfix -q --out=${png/.png/fixed.png} ${png} # see pngfix help for exit codes
		[[ $? -gt 15 ]] && die "Failed to fix ${png}"
		mv -f ${png/.png/fixed.png} ${png} || die
	fi
}

src_install() {
	dodoc *.pdf

	if use html ; then
		docinto html
		dodoc -r html-en/*

		local lang
		for lang in ${LANGS} ; do
			use l10n_${lang} || continue
			docinto html-${lang}
			dodoc -r html-${lang}/*
		done
	fi
}
