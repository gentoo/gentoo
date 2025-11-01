# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Definitions of many terms in the Algol 68 language context"
HOMEPAGE="https://jemarch.net/a68-jargon/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.sr.ht/~jemarch/a68-jargon"
	inherit git-r3
else
	JARGON_COMMIT="07940f3a40be1a49bcd56603bb671809885f9c12"
	SRC_URI="https://git.sr.ht/~jemarch/a68-jargon/archive/${JARGON_COMMIT}.tar.gz -> ${P}.srht.tar.gz"
	S="${WORKDIR}"/${PN}-${JARGON_COMMIT}

	KEYWORDS="~amd64"
fi

LICENSE="|| ( FDL-1.3+ GPL-3+ ) public-domain"
SLOT="0"
IUSE="pdf"

BDEPEND="
	sys-apps/texinfo
	pdf? (
		app-text/ghostscript-gpl
		app-text/texlive-core
		virtual/texi2dvi
	)
"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake all $(usev pdf 'pdf')
}

src_install() {
	emake DESTDIR="${D}" install $(usev pdf 'install-pdf')
}
