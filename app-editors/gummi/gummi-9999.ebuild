# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils

DESCRIPTION="Simple LaTeX editor for GTK+ users"
HOMEPAGE="https://github.com/alexandervdm/gummi"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alexandervdm/gummi.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/alexandervdm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

LANGS="ar ca cs da de el es fr hu it nl pl pt pt_BR ro ru sv zh_CN zh_TW"

for X in ${LANGS} ; do
	IUSE="${IUSE} +linguas_${X}"
done

RDEPEND="
	dev-libs/glib:2
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	x11-libs/gtk+:2"

DEPEND="${RDEPEND}
	app-text/gtkspell:2
	app-text/poppler[cairo]
	x11-libs/gtksourceview:2.0
	x11-libs/pango"

DOCS=( AUTHORS ChangeLog README.md )

src_prepare() {
	strip-linguas ${LANGS}
	eautoreconf
}

pkg_postinst() {
	elog "Gummi >=0.4.8 supports spell-checking through gtkspell. Support for"
	elog "additional languages can be added by installing myspell-** packages"
	elog "for your language of choice."
}
