# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="GNU C Language Intro and Reference Manual"
HOMEPAGE="https://savannah.gnu.org/projects/c-intro-and-ref/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/c-intro-and-ref.git"
	inherit git-r3
else
	MY_COMMIT="62962013107481127176ef04d69826e41f51313c"
	SRC_URI="https://git.savannah.nongnu.org/cgit/c-intro-and-ref.git/snapshot/c-intro-and-ref-${MY_COMMIT}.tar.gz"
	S="${WORKDIR}"/c-intro-and-ref-${MY_COMMIT}
	KEYWORDS="~amd64"
fi

LICENSE="FDL-1.3+"
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
	emake info html $(usev pdf 'pdf')
}

src_install() {
	emake DESTDIR="${D}" install-info install-html $(usev pdf 'install-pdf')
}
