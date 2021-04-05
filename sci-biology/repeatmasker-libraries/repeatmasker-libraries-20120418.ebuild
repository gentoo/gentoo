# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A special version of RepBase used by RepeatMasker"
HOMEPAGE="http://repeatmasker.org/"
SRC_URI="repeatmaskerlibraries-${PV}.tar.gz"
S="${WORKDIR}/Libraries"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please register and download repeatmaskerlibraries-${PV}.tar.gz"
	einfo 'at http://www.girinst.org/'
	einfo '(select the "Repbase Update - RepeatMasker edition" link)'
	einfo 'and place it into your DISTDIR directory.'
}

src_install() {
	HTML_DOCS=( README.html )
	einstalldocs

	insinto /usr/share/repeatmasker/Libraries
	doins RepeatMaskerLib.embl
}
