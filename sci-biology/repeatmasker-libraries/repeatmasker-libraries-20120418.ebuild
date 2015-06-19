# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/repeatmasker-libraries/repeatmasker-libraries-20120418.ebuild,v 1.1 2013/03/07 13:35:15 jlec Exp $

EAPI=5

DESCRIPTION="A special version of RepBase used by RepeatMasker"
HOMEPAGE="http://repeatmasker.org/"
SRC_URI="repeatmaskerlibraries-${PV}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/Libraries"

RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please register and download repeatmaskerlibraries-${PV}.tar.gz"
	einfo 'at http://www.girinst.org/'
	einfo '(select the "Repbase Update - RepeatMasker edition" link)'
	einfo 'and place it in '${DISTDIR}
}

src_install() {
	insinto /usr/share/repeatmasker/Libraries
	doins "${S}"/RepeatMaskerLib.embl
	dodoc README
	dohtml README.html
}
